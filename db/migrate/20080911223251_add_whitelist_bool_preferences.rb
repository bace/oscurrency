class AddWhitelistBoolPreferences < ActiveRecord::Migration[4.2]
  def self.up
    add_column :preferences, :whitelist, :boolean, :default => false
  end

  def self.down
    remove_column :preferences, :whitelist
  end
end
