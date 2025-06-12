class AddExceptionNotificationPreferences < ActiveRecord::Migration[4.2]
  def self.up
    add_column :preferences, :exception_notification, :string
  end

  def self.down
    remove_column :preferences, :exception_notification
  end
end
