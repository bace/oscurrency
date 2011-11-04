class AddAccountantToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :accountant, :boolean, :default => false
  end

  def self.down
    remove_column :people, :accountant
  end
end
