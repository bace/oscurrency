class RemoveForumNotificationsFromPeople < ActiveRecord::Migration[4.2]
  def up
    remove_column :people, :forum_notifications
  end

  def down
    add_column :people, :forum_notifications, :boolean, :default => false
  end
end
