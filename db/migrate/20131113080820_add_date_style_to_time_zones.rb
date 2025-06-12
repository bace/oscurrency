class AddDateStyleToTimeZones < ActiveRecord::Migration[4.2]
  def change
    add_column :time_zones, :date_style, :string, :default => 'mm/dd/yy'
  end
end
