class AddNameIndexesToPeople < ActiveRecord::Migration[4.2]
  def change
  	add_index :people, :name
  	add_index :people, :business_name
  end
end
