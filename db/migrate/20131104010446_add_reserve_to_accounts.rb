class AddReserveToAccounts < ActiveRecord::Migration[4.2]
  def change
    add_column :accounts, :reserve, :boolean, :default => false
  end
end
