class AddLogicalDeleteToExchange < ActiveRecord::Migration[4.2]
  def up
    add_column :exchanges, :deleted_at, :time
  end

  def down
    remove_column :exchanges, :deleted_at
  end
end
