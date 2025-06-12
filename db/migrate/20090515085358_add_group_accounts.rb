class AddGroupAccounts < ActiveRecord::Migration[4.2]
  def self.up
    add_column :accounts, :group_id, :integer
  end

  def self.down
    remove_column :accounts, :group_id
  end
end
