class RemoveGroupOptionFromPreferences < ActiveRecord::Migration[4.2]
  def self.up
    remove_column :preferences, :group_option
  end

  def self.down
    add_column :preferences, :group_option, :boolean, :default => true
  end
end
