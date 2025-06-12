class AddGroupOptionPreferences < ActiveRecord::Migration[4.2]
  def self.up
    add_column :preferences, :group_option, :boolean, :default => false
  end

  def self.down
    remove_column :preferences, :group_option
  end
end
