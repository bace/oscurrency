class AddPublicUploadsToPreferences < ActiveRecord::Migration[4.2]
  def change
    add_column :preferences, :public_uploads, :boolean, :default => false
  end
end
