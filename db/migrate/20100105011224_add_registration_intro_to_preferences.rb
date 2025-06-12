class AddRegistrationIntroToPreferences < ActiveRecord::Migration[4.2]
  def self.up
    add_column :preferences, :registration_intro, :text
  end

  def self.down
    remove_column :preferences, :registration_intro
  end
end
