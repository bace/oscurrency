class AddGroupExchanges < ActiveRecord::Migration[4.2]
  def self.up
    add_column :exchanges, :group_id, :integer
  end

  def self.down
    remove_column :exchanges, :group_id
  end
end
