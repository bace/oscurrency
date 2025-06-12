class AddDefaultGroupPeople < ActiveRecord::Migration[4.2]
  def self.up
    add_column :people, :default_group_id, :integer
  end

  def self.down
    remove_column :people, :default_group_id
  end
end
