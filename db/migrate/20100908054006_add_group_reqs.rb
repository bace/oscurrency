class AddGroupReqs < ActiveRecord::Migration[4.2]
  def self.up
    add_column :reqs, :group_id, :integer
  end

  def self.down
    remove_column :reqs, :group_id
  end
end
