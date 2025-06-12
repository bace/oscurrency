class CreateMemberPreferences < ActiveRecord::Migration[4.2]
  def self.up
    create_table :member_preferences do |t|
      t.boolean :req_notifications, :default => true
      t.boolean :forum_notifications, :default => true
      t.integer :membership_id

      t.timestamps
    end
  end

  def self.down
    drop_table :member_preferences
  end
end
