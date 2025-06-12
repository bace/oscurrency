class AddForumNotificationsPeople < ActiveRecord::Migration[4.2]
  def self.up
    add_column :people, :forum_notifications, :boolean, :default => false
  end

  def self.down
    remove_column :people, :forum_notifications
  end
end
