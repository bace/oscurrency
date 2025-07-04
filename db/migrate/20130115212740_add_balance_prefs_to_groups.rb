class AddBalancePrefsToGroups < ActiveRecord::Migration[4.2]
  def change
    add_column :groups, :display_balance, :boolean, :default => true
    add_column :groups, :display_earned, :boolean, :default => false
    add_column :groups, :display_paid, :boolean, :default => false
  end
end
