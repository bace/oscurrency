class AddDefaultGroupToPreferences < ActiveRecord::Migration[4.2]
  def self.up
    add_column :preferences, :default_group_id, :integer
  end

  def self.down
    remove_column :preferences, :default_group_id
  end
end
