class AddProtectedCategoriesToPreferences < ActiveRecord::Migration[4.2]
  def change
    add_column :preferences, :protected_categories, :boolean, :default => false
  end
end
