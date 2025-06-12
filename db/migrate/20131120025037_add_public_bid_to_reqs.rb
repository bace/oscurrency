class AddPublicBidToReqs < ActiveRecord::Migration[4.2]
  def change
    add_column :reqs, :public_bid, :boolean, :default => false
  end
end
