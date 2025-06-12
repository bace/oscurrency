class AddOpenIdIdentifierToPerson < ActiveRecord::Migration[4.2]
  def self.up
    add_column :people, :openid_identifier, :string
  end

  def self.down
    remove_column :people, :openid_identifier
  end
end
