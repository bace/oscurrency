class AddPrivacyToAddress < ActiveRecord::Migration[4.2]
  def self.up
    add_column :addresses, :address_privacy, :boolean, :default => false
  end

  def self.down
    remove_column :addresses, :address_privacy
  end
end
