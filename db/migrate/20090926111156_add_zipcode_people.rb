class AddZipcodePeople < ActiveRecord::Migration[4.2]
  def self.up
    add_column :people, :zipcode, :string
  end

  def self.down
    remove_column :people, :zipcode
  end
end
