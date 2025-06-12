class AddTwitterApiPreferences < ActiveRecord::Migration[4.2]
  def self.up
    add_column :preferences, :twitter_api, :string
  end

  def self.down
    remove_column :preferences, :twitter_api
  end
end
