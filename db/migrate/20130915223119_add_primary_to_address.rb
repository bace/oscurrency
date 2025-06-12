class AddPrimaryToAddress < ActiveRecord::Migration[4.2]
  def change
    add_column :addresses, :primary, :boolean, :default => false
  end
end
