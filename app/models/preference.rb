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
#  display_orgicon                       :boolean(1)      default(true)

class Preference < ApplicationRecord
  validate :enforce_singleton, :on => :create

  belongs_to :default_group, :class_name => "Group", :foreign_key => "default_group_id"

  # default profile picture and default group picture
  has_many :photos, -> { order('created_at') }, :as => :photoable, :dependent => :destroy

  def policy
    steps
  end

  def default_group_id_enum
    Group.all.map {|g| [g.name,g.id]}
  end

  def admin_contact_id_enum
    Person.where(admin: true).order(:created_at).map {|p| [p.name,p.id]}
  end

  def locale_enum
    [['English','en'],['Spanish','es'],['French','fr'],['Greek','gr']]
  end

  # Can we send mail with the present configuration?
  def can_send_email?
    not (ENV['SMTP_DOMAIN'].blank? or ENV['SMTP_SERVER'].blank?)
  end

  def enforce_singleton
    unless Preference.all.count == 0
      errors.add :base, "Attempting to instantiate another Preference object"
    end
  end

  def using_email?
    email_notifications? or email_verifications?
  end

  def default_profile_picture
    self.photos.find_by_picture_for('profile')
  end

  def default_group_picture
    self.photos.find_by_picture_for('group')
  end

  alias_attribute :faq, :questions

  class << self

    def profile_image version = nil
      if version
        Preference.first.default_profile_picture.picture_url(version)
      else
        Preference.first.default_profile_picture.picture_url
      end
    rescue NoMethodError => e
      # default_profile_picture will be nil the first time profile_image() is called. create it here.
      photo = Preference.first.photos.new(:picture_for => 'profile')
      photo.picture = File.open(File.join(Rails.root, 'public/images/default.png'))
      photo.save!
      version.nil? ? photo.picture_url : photo.picture_url(version)
    end

    def group_image version = nil
      if version
        Preference.first.default_group_picture.picture_url(version)
      else
        Preference.first.default_group_picture.picture_url
      end
    rescue NoMethodError => e
      # default_group_picture will be nil the first time group_image() is called. create it here.
      photo = Preference.first.photos.new(:picture_for => 'group')
      photo.picture = File.open(File.join(Rails.root, 'public/images/g_default.png'))
      photo.save!
      version.nil? ? photo.picture_url : photo.picture_url(version)
    end

  end
end
