# == Schema Information
# Schema version: 20090216032013
#
# Table name: communications
#
#  id                   :integer(4)      not null, primary key
#  subject              :string(255)     
#  content              :text            
#  parent_id            :integer(4)      
#  conversation_id      :integer(4)      
#  sender_id            :integer(4)      
#  recipient_id         :integer(4)      
#  sender_deleted_at    :datetime        
#  sender_read_at       :datetime        
#  recipient_deleted_at :datetime        
#  recipient_read_at    :datetime        
#  replied_at           :datetime        
#  type                 :string(255)     
#  created_at           :datetime        
#  updated_at           :datetime        

#

class Message < Communication
  extend PreferencesHelper
  
  attr_accessor :reply, :send_mail

  # sadly not implemented by texticle
  #              :conditions => "recipient_deleted_at IS NULL"
  index do
    subject
    content
  end

  MAX_CONTENT_LENGTH = 20000
  SEARCH_LIMIT = 20
  SEARCH_PER_PAGE = 8

  # ARGH, this breaks Message.create in some horrible way. Who designed this POS (Rails that is)?
  #  attr_accessible :subject, :content
  
  belongs_to :parent, :class_name => 'Message', :foreign_key => 'parent_id'
  belongs_to :sender, :class_name => 'Person', :foreign_key => 'sender_id'
  belongs_to :recipient, :class_name => 'Person', :foreign_key => 'recipient_id'
  belongs_to :conversation
  validates_presence_of :subject, :content
  validates_length_of :subject, :maximum => 200
  validates_length_of :content, :maximum => MAX_CONTENT_LENGTH

  # lets say this is optional
  # the only place conversations are actually used is ./views/messages/show.html.erb
  before_create :assign_conversation
  after_create :update_recipient_last_contacted_at,
  :save_recipient, :set_replied_to, :send_receipt_reminder
  
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
      !sender_deleted_at.nil? and sender_deleted_at > Person::TRASH_TIME_AGO
    when recipient
      !recipient_deleted_at.nil? and 
        recipient_deleted_at > Person::TRASH_TIME_AGO
    end
  end
  
  # Return true if the message is a reply to a previous message.
  def reply?
    (!parent.nil? or !parent_id.nil?) and valid_reply?
  end
  
  # Return true if the sender/recipient pair is valid for a given parent.
  # +++ check that this works for nil sender
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

  def perform
    begin
      actually_send_receipt_reminder
    rescue Net::SMTPServerBusy => e
      # +++ all mail sending should have this apparatus around it.  
      # message should stay queued
      logger.info "Temp SMTP error #{e} for #{self}"
    end
  end

  private

  # Assign the conversation id.
  # This is the parent message's conversation unless there is no parent,
  # in which case we create a new conversation.
  def assign_conversation
    self.conversation = parent.nil? ? Conversation.create :
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
    self.recipient.save(perform_validation = false) || raise(RecordNotSaved)
  end
  
  def send_receipt_reminder
    Cheepnis.enqueue(self)
  end

  def actually_send_receipt_reminder
    #      return if sender == recipient
    @send_mail ||= Message.global_prefs.email_notifications? &&
      recipient.message_notifications?
    PersonMailer.deliver_message_notification(self) if @send_mail
  end
end
