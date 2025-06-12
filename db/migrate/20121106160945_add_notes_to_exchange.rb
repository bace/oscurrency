class AddNotesToExchange < ActiveRecord::Migration[4.2]
  def change
    add_column :exchanges, :notes, :string, :limit => 255
  end
end
