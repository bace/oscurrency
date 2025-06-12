class AddPrivateTxnsToGroups < ActiveRecord::Migration[4.2]
  def change
    add_column :groups, :private_txns, :boolean, :default => false
  end
end
