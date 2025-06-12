class AddSponsorToPeople < ActiveRecord::Migration[4.2]
  def self.up
    add_column :people, :sponsor_id, :integer
  end

  def self.down
    remove_column :people, :sponsor_id
  end
end
