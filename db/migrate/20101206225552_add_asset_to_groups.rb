class AddAssetToGroups < ActiveRecord::Migration[4.2]
  def self.up
    add_column :groups, :asset, :string
  end

  def self.down
    remove_column :groups, :asset
  end
end
