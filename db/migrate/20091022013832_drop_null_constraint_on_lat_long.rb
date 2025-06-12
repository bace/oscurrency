class DropNullConstraintOnLatLong < ActiveRecord::Migration[4.2]
  def self.up
    change_column :addresses, :latitude, :decimal, :null => :true, :precision => 12, :scale => 8
    change_column :addresses, :longitude, :decimal, :null => :true, :precision => 12, :scale => 8
  end

  def self.down
  end
end
