class AddRolesMaskToMemberships < ActiveRecord::Migration[4.2]
  def self.up
    add_column :memberships, :roles_mask, :integer
  end

  def self.down
    remove_column :memberships, :roles_mask
  end
end
