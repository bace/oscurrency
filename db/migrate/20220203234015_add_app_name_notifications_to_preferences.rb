class AddAppNameNotificationsToPreferences < ActiveRecord::Migration[4.2]
  def change
    add_column :preferences, :app_name_notifications, :string, :default => ""
  end
end
