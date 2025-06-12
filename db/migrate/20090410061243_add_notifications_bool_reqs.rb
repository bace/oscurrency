class AddNotificationsBoolReqs < ActiveRecord::Migration[4.2]
  def self.up
    add_column :reqs, :notifications, :boolean, :default => false
  end

  def self.down
    remove_column :reqs, :notifications
  end
end
