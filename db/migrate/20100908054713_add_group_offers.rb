class AddGroupOffers < ActiveRecord::Migration[4.2]
  def self.up
    add_column :offers, :group_id, :integer
  end

  def self.down
    remove_column :offers, :group_id
  end
end
