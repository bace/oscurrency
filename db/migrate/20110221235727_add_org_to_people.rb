class AddOrgToPeople < ActiveRecord::Migration[4.2]
  def self.up
    add_column :people, :org, :boolean, :default => false
  end

  def self.down
    remove_column :people, :org
  end
end
