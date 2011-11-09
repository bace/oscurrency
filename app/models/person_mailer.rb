class PersonMailer < ActionMailer::Base
  extend PreferencesHelper
  
  def domain
    @domain ||= PersonMailer.global_prefs.domain
  end
  
  def server
    @server ||= PersonMailer.global_prefs.server_name
  end
  
  def password_reset(person)
    from         "Password reset <password-reset@#{domain}>"
    recipients   person.email
    subject      formatted_subject("Password reset")
    body         "server" => server, "person" => person
    content_type "text/html"
  end
  
  def message_notification(message)
    # +++ these probably want to be parameters
    sender_name = message.sender ? message.sender.name : "Time Exchange Notes"
    sender_email = message.sender ? message.sender.email : "notes@#{Req.global_prefs.domain}"
    from         "#{sender_name} <#{sender_email}>"
    reply_to     "#{sender_name} <#{sender_email}>"
    recipients   message.recipient.email
    subject      formatted_subject(message.subject)
    content_type "text/html"
    body         "server" => server, "message" => message,
    "preferences_note" => preferences_note(message.recipient)
  end
  
  def temp_message_notification(message)
    message_notification(message)
  end
  
  def connection_request(connection)
    from         "#{connection.contact.name} <connection@#{domain}>"
    recipients   connection.person.email
    subject      formatted_subject("New contact request")
    body         "server" => server,
    "connection" => connection,
    "url" => edit_connection_path(connection),
    "preferences_note" => preferences_note(connection.person)
  end
  
  def membership_public_group(membership)
    from         "#{membership.group.name} <membership@#{domain}>"
    recipients   membership.group.owner.email
    subject      formatted_subject("#{membership.person.name} joined group #{membership.group.name}")
    body         "server" => server,
    "membership" => membership,
    "url" => members_group_path(membership.group),
    "preferences_note" => preferences_note(membership.group.owner)
  end
  
  def membership_request(membership)
    from         "#{membership.group.name} <membership@#{domain}>"
    recipients   membership.group.owner.email
    subject      formatted_subject("#{membership.person.name} wants to join group #{membership.group.name}")
    body         "server" => server,
    "membership" => membership,
    "url" => members_group_path(membership.group),
    "preferences_note" => preferences_note(membership.group.owner)
  end
  
  def membership_accepted(membership)
    from         "#{membership.group.name} <membership@#{domain}>"
    recipients   membership.person.email
    subject      formatted_subject("You have been accepted to join #{membership.group.name}")
    body         "server" => server,
    "membership" => membership,
    "url" => group_path(membership.group),
    "preferences_note" => preferences_note(membership.person)
  end
  
  def invitation_notification(membership, custom_message)
    from         "#{membership.group.name} <invitation#{domain}>"
    recipients   membership.person.email
    subject      formatted_subject("Invitation from group #{membership.group.name}")
    body         "server" => server,
    "membership" => membership,
    "custom_message" => custom_message,
    "url" => edit_membership_path(membership),
    "preferences_note" => preferences_note(membership.person)
  end
  
  def invitation_accepted(membership)
    from         "#{membership.group.name} <invitation@#{domain}>"
    recipients   membership.group.owner.email
    subject      formatted_subject("#{membership.person.name} accepted the invitation")
    body         "server" => server,
    "membership" => membership,
    "url" => members_group_path(membership.group),
    "preferences_note" => preferences_note(membership.group.owner)
  end
  
  def blog_comment_notification(comment)
    from         "Blog <comment@#{domain}>"
    recipients   comment.commented_person.email
    subject      formatted_subject("New blog comment")
    body         "server" => server, "comment" => comment,
    "url" => 
      blog_post_path(comment.commentable.blog, comment.commentable),
    "preferences_note" => 
      preferences_note(comment.commented_person)
  end
  
  def wall_comment_notification(comment)
    from         "Wall <comment@#{domain}>"
    recipients   comment.commented_person.email
    subject      formatted_subject("New wall comment")
    body         "server" => server, "comment" => comment,
    "url" => person_path(comment.commentable, :anchor => "wall"),
    "preferences_note" => 
      preferences_note(comment.commented_person)
  end
  
  def forum_post_notification(subscriber, forum_post)
    from         "#{forum_post.person.name} <forum@#{domain}>"
    recipients   subscriber.email
    subject      formatted_group_subject(forum_post.topic.forum.group, forum_post.topic.name)
    content_type "text/html"
    body         "server" => server, "forum_post" => forum_post,
    "preferences_note" => 
      preferences_note(subscriber)
  end

  def email_verification(ev)
    from         "Email verification <email@#{domain}>"
    recipients   ev.person.email
    subject      formatted_subject("Email verification")
    body         "server_name" => server,
    "code" => ev.code
  end

  def registration_notification(new_peep)
    from         "Registration notification <registration@#{domain}>"
    recipients   PersonMailer.global_prefs.new_member_notification.split
    subject      formatted_subject("New registration")
    body         "email" => new_peep.email,
    "name" => new_peep.name,
    "server" => server,
    "url" => person_path(new_peep)
  end

  def req_notification(req, recipient)
    from         "#{req.person.name} <#{req.person.email}>"
    reply_to     "#{req.person.name} <#{req.person.email}>"
    recipients   recipient.email
    subject      formatted_subject("#{req.name} request")
    body         "name" => req.name,
                 "description" => req.description,
                 "server" => server,
                 "requestor" => req.person.name,
                 "url" => req_path(req)
  end

  def offer_notification(offer, recipient)
    from         "#{offer.person.name} <#{offer.person.email}>"
    reply_to     "#{offer.person.name} <#{offer.person.email}>"
    recipients   recipient.email
    subject      formatted_subject("#{offer.name} offered")
    body         "name" => offer.name,
                 "description" => offer.description,
                 "server" => server,
                 "offerer" => offer.person.name,
                 "url" => offer_path(offer)
  end
  
  private
  
  # Prepend the application name to subjects if present in preferences.
  def formatted_subject(text)
    name = PersonMailer.global_prefs.app_name
    label = name.blank? ? "" : "[#{name}] "
    "#{label}#{text}"
  end

  def formatted_group_subject(group,text)
    if !group
      formatted_subject(text)
    else
      "[#{group.name}] #{text}"
    end
  end
  
  def preferences_note(person)
    %(To change your email notification preferences, visit
      
http://#{server}/people/#{person.to_param}/edit)
  end

# moved to forum_post
#   def send_forum_post_mailing(options)
#     @forum_post = ForumPost.find(options[:forum_post_id])
#     @group = @forum_post.topic.forum.group
#     if !@group
#       peeps = Person.all_listening_to_forum_posts
#     else
#       # XXX add a notifications boolean to memberships table
#       #
#       peeps = @group.people
#     end

#     peeps.each do |peep|
#       logger.info("MailingsWorker forum_post: sending email to #{peep.id}: #{peep.name}")
#       PersonMailer.deliver_forum_post_notification(peep,@forum_post)
#     end
#   end



end
