# == Schema Information
# Schema version: 20090216032013
#
# Table name: preferences
#
#  id                                    :integer(4)      not null, primary key
#  domain                                :string(255)     default(""), not null
#  smtp_server                           :string(255)     default(""), not null
#  email_notifications                   :boolean(1)      not null
#  email_verifications                   :boolean(1)      not null
#  created_at                            :datetime        
#  updated_at                            :datetime        
#  analytics                             :text            
#  server_name                           :string(255)     
#  app_name                              :string(255)     
#  about                                 :text            
#  demo                                  :boolean(1)      
#  email_notices                                  :boolean(1)      
#  whitelist                             :boolean(1)      
#  gmail                                 :string(255)     
#  exception_notification                :string(255)     
#  registration_notification             :boolean(1)      
#  practice                              :text            
#  steps                                 :text            
#  questions                             :text            
#  memberships                           :text            
#  contact                               :text            
#  twitter_name                          :string(255)     
#  crypted_twitter_password              :string(255)     
#  twitter_api                           :string(255)     
#  twitter_oauth_consumer_key            :string(255)     
#  crypted_twitter_oauth_consumer_secret :string(255)     
#

class Preference < ActiveRecord::Base
  attr_accessible :app_name, :server_name, :domain, :smtp_server, 
                  :exception_notification, :new_member_notification,
                  :email_notifications, :email_verifications, :analytics,
                  :about, :demo, :email_notices, :whitelist, :gmail, :welcome, :short_about,
                  :practice, :steps, :questions, :contact,
                  :registration_intro,
                  :agreement,
                  :group_option,
                  :zipcode_browsing,
                  :blog_feed_url,
                  :googlemap_api_key

  validates_presence_of :domain,       :if => :using_email?
  validates_presence_of :smtp_server,  :if => :using_email?
  
  # Can we send mail with the present configuration?
  def can_send_email?
    not (domain.blank? or smtp_server.blank?)
  end

  private
    def decrypt(password)
      k = LocalEncryptionKey.find(:first)
      Crypto::Key.from_local_key_value(k.rsa_private_key).decrypt(password)
    end

    def self.encrypt(password)
      k = LocalEncryptionKey.find(:first)
      Crypto::Key.from_local_key_value(k.rsa_public_key).encrypt(password)
    end
  
    # Encrypts the password with the user salt
    def encrypt(password)
      self.class.encrypt(password)
    end

    def using_email?
      email_notifications? or email_verifications?
    end
end
