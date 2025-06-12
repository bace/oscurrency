class AddAboutToPreferences < ActiveRecord::Migration[4.2]
  def self.up
    add_column :preferences, :about, :text
  end

  def self.down
    remove_column :preferences, :about
  end
end
