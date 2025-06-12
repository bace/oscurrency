class RemoveZipcodeBrowsingFromPreferences < ActiveRecord::Migration[4.2]
  def up
    remove_column :preferences, :zipcode_browsing
  end

  def down
    add_column :preferences, :zipcode_browsing, :boolean, :default => false
  end
end
