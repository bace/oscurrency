class AddPhoneprivacyBoolPeople < ActiveRecord::Migration[4.2]
  def self.up
    add_column :people, :phoneprivacy, :boolean, :default => false
  end

  def self.down
    remove_column :people, :phoneprivacy
  end
end
