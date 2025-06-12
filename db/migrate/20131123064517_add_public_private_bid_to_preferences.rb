class AddPublicPrivateBidToPreferences < ActiveRecord::Migration[4.2]
  def change
    add_column :preferences, :public_private_bid, :boolean, :default => false
  end
end
