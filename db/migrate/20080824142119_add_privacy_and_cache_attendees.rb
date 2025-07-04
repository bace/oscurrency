class AddPrivacyAndCacheAttendees < ActiveRecord::Migration[4.2]
  def self.up
    add_column :events, :event_attendees_count, :integer, :default => 0
    add_column :events, :privacy, :integer, :null => false, :default => 2
  end

  def self.down
    remove_column :events, :event_attendees_count
    remove_column :events, :privacy
  end
end
