class AddLogoutUrlToPreferences < ActiveRecord::Migration[4.2]
  def change
    add_column :preferences, :logout_url, :string, :default => ""
  end
end
