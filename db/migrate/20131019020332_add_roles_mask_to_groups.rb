class AddRolesMaskToGroups < ActiveRecord::Migration[4.2]
  def change
    add_column :groups, :roles_mask, :integer
  end
end
