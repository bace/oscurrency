class AddWorldwritableToForums < ActiveRecord::Migration[4.2]
  def self.up
    add_column :forums, :worldwritable, :boolean, :default => false
  end

  def self.down
    remove_column :forums, :worldwritable
  end
end
