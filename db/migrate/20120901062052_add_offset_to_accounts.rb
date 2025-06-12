class AddOffsetToAccounts < ActiveRecord::Migration[4.2]
  def change
    add_column :accounts, :offset, :decimal, :precision => 8, :scale => 2, :default => 0
  end
end
