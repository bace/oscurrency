class AddPrivateMessageToRequestorBids < ActiveRecord::Migration[4.2]
  def self.up
    add_column :bids, :private_message_to_requestor, :text
  end

  def self.down
    remove_column :bids, :private_message_to_requestor
  end
end
