class AddUnitGroups < ActiveRecord::Migration[4.2]
  def self.up
    add_column :groups, :unit, :string
  end

  def self.down
    remove_column :groups, :unit
  end
end
