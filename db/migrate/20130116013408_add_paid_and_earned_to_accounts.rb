class AddPaidAndEarnedToAccounts < ActiveRecord::Migration[4.2]
  def change
    add_column :accounts, :paid, :decimal, :precision => 8, :scale => 2, :default => 0
    add_column :accounts, :earned, :decimal, :precision => 8, :scale => 2, :default => 0
  end
end
