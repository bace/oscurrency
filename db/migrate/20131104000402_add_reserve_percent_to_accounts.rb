class AddReservePercentToAccounts < ActiveRecord::Migration[4.2]
  def change
    add_column :accounts, :reserve_percent, :decimal, :precision => 8, :scale => 7, :default => 0
  end
end
