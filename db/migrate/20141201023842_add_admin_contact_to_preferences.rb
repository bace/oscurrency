class AddAdminContactToPreferences < ActiveRecord::Migration[4.2]
  def change
    add_column :preferences, :admin_contact_id, :integer
  end
end
