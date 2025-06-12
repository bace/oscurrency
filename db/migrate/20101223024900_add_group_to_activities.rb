class AddGroupToActivities < ActiveRecord::Migration[4.2]
  def self.up
    add_column :activities, :group_id, :integer
  end

  def self.down
    remove_column :activities, :group_id
  end
end
