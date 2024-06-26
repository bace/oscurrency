class Message < Communication
  extend PreferencesHelper
  include ActionView::Helpers::TextHelper
  
  attr_accessor :reply, :parent, :send_mail, :talkable_id, :talkable_type, :exchange

  MAX_CONTENT_LENGTH = 5000

  belongs_to :sender, :class_name => 'Person', :foreign_key => 'sender_id'
  belongs_to :recipient, :class_name => 'Person',
                         :foreign_key => 'recipient_id'
  belongs_to :conversation
  validates_presence_of :subject, :content, :recipient
  validates_length_of :subject, :maximum => 80
  validates_length_of :content, :maximum => MAX_CONTENT_LENGTH

  before_create :assign_conversation
  before_save :truncate_subject
  after_create :update_recipient_last_contacted_at,
               :set_replied_to, :send_receipt_reminder
               #:save_recipient

  class << self
    def search_by(text)
      where(Message.arel_table[:subject].matches("%#{text}%").or(Message.arel_table[:content].matches("%#{text}%")))
    end
  end

  def parent
    return @parent unless @parent.nil?
    return Message.find(parent_id) unless parent_id.nil?
  end
  
  def parent=(message)
    self.parent_id = message.id
    @parent = message
  end
  
  # Return the sender/recipient that *isn't* the given person.
  def other_person(person)
    person == sender ? recipient : sender
  end

  # Put the message in the trash for the given person.
  def trash(person, time=Time.now)
    case person
    when sender
      self.sender_deleted_at = time
    when recipient
      self.recipient_deleted_at = time
    else
      # Given our controller before filters, this should never happen...
      raise ArgumentError,  "Unauthorized person"
    end
    save!
  end
  
  # Move the message back to the inbox.
  def untrash(user)
    return false unless trashed?(user)
    trash(user, nil)
  end
  
  # Return true if the message has been trashed.
  def trashed?(person)
    case person
    when sender
      !sender_deleted_at.nil?
    when recipient
      !recipient_deleted_at.nil?
    end
  end
  
  # Return true if the message is a reply to a previous message.
  def reply?
    (!parent.nil? or !parent_id.nil?) and valid_reply?
  end
  
  # Return true if the sender/recipient pair is valid for a given parent.
  def valid_reply?
    # People can send multiple replies to the same message, in which case
    # the recipient is the same as the parent recipient.
    # For most replies, the message recipient should be the parent sender.
    # We use Set to handle both cases uniformly.
    Set.new([sender, recipient]) == Set.new([parent.sender, parent.recipient])
  end
  
  # Return true if pair of people is valid.
  def valid_reply_pair?(person, other)
    ((recipient == person and sender == other) or
     (recipient == other  and sender == person))
  end
  
  # Return true if the message has been replied to.
  def replied_to?
    !replied_at.nil?
  end
  
  # Mark a message as read.
  def mark_as_read(time = Time.now)
    unless read?
      self.recipient_read_at = time
      save!
    end
  end
  
  # Return true if a message has been read.
  def read?
    !recipient_read_at.nil?
  end

  def truncate_subject
    self.subject = truncate self.subject, :length => 75, :omission => "..."
  end

  private

    # Assign the conversation id.
    # This is the parent message's conversation unless there is no parent,
    # in which case we create a new conversation.
    def assign_conversation
      self.conversation = parent.nil? ? Conversation.create(:talkable_id => talkable_id, :talkable_type => talkable_type, :exchange => self.exchange) :
                                        parent.conversation
    end
  
    # Mark the parent message as replied to if the current message is a reply.
    def set_replied_to
      if reply?
        parent.replied_at = Time.now
        parent.save!
      end
    end
    
    def update_recipient_last_contacted_at
      self.recipient.last_contacted_at = updated_at
    end
    
    def save_recipient
      #self.recipient.save!
    end
    
    def send_mail?
      @send_mail ||= Message.global_prefs and
                     Message.global_prefs.email_notifications? and
                     recipient.message_notifications?
    end

    def send_receipt_reminder
      return if sender == recipient or not send_mail?
      after_transaction { PersonMailerQueue.message_notification(self) }
    end
end
