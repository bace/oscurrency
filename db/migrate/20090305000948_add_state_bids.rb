class AddStateBids < ActiveRecord::Migration[4.2]
  def self.up
    add_column :bids, :state, :string
  end

  def self.down
    remove_column :bids, :state
  end
end
