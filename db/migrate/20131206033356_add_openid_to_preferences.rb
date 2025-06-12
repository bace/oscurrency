class AddOpenidToPreferences < ActiveRecord::Migration[4.2]
  def change
    add_column :preferences, :openid, :boolean, :default => true
  end
end
