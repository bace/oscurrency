class AddLocaleToPreferences < ActiveRecord::Migration[4.2]
  def change
    add_column :preferences, :locale, :string
  end
end
