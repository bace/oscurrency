class AddDemoBoolean < ActiveRecord::Migration[4.2]
  def self.up
    add_column :preferences, :demo, :boolean, :default => false
  end

  def self.down
    remove_column :preferences, :demo
  end
end
