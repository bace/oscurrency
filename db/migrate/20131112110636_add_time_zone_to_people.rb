class AddTimeZoneToPeople < ActiveRecord::Migration[4.2]
  def change
    add_column :people, :time_zone, :string
  end
end
