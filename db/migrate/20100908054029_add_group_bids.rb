class AddGroupBids < ActiveRecord::Migration[4.2]
  def self.up
    add_column :bids, :group_id, :integer
  end

  def self.down
    remove_column :bids, :group_id
  end
end
