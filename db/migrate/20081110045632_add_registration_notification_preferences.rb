class AddRegistrationNotificationPreferences < ActiveRecord::Migration[4.2]
  def self.up
    add_column :preferences, :registration_notification, :boolean, :default => false
  end

  def self.down
    remove_column :preferences, :registration_notification
  end
end
