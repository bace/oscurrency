class AddPerishableTokenToPeople < ActiveRecord::Migration[4.2]
  def self.up
    add_column :people, :perishable_token, :string, :default => "", :null => false
    add_index :people, :perishable_token
  end

  def self.down
    remove_column :people, :perishable_token
  end
end
