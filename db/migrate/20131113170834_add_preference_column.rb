#TKT334 display organization icon with a preference option
class AddPreferenceColumn < ActiveRecord::Migration[4.2]
  def up
    add_column :preferences, :display_orgicon, :boolean, :default =>  true
  end

  def down
    remove_column :preferences, :display_orgicon
  end
end
