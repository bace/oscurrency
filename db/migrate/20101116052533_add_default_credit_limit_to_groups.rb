class AddDefaultCreditLimitToGroups < ActiveRecord::Migration[4.2]
  def self.up
   add_column :groups, :default_credit_limit, :decimal, :precision => 8, :scale => 2, :default => nil
  end

  def self.down
    remove_column :groups, :default_credit_limit
  end
end
