class AddActivatorToPeople < ActiveRecord::Migration[4.2]
  def self.up
    add_column :people, :activator, :boolean, :default => false
  end

  def self.down
    remove_column :people, :activator
  end
end
