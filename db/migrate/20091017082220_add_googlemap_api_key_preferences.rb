class AddGooglemapApiKeyPreferences < ActiveRecord::Migration[4.2]
  def self.up
    add_column :preferences, :googlemap_api_key, :string
  end

  def self.down
    remove_column :preferences, :googlemap_api_key
  end
end
