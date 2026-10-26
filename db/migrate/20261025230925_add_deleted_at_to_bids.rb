class AddDeletedAtToBids < ActiveRecord::Migration[6.1]
  def change
    add_column :bids, :deleted_at, :datetime
    add_index :bids, :deleted_at
  end
end
