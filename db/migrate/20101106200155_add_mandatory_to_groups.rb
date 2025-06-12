class AddMandatoryToGroups < ActiveRecord::Migration[4.2]
  def self.up
    add_column :groups, :mandatory, :boolean, :default => false
  end

  def self.down
    remove_column :groups, :mandatory
  end
end
