class AddGroupForum < ActiveRecord::Migration[4.2]
  def self.up
    add_column :forums, :group_id, :integer
  end

  def self.down
    remove_column :forums, :group_id
  end
end
