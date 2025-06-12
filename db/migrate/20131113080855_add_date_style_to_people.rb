class AddDateStyleToPeople < ActiveRecord::Migration[4.2]
  def change
    add_column :people, :date_style, :string
  end
end
