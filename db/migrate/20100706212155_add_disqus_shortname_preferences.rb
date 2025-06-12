class AddDisqusShortnamePreferences < ActiveRecord::Migration[4.2]
  def self.up
    add_column :preferences, :disqus_shortname, :string
  end

  def self.down
    remove_column :preferences, :disqus_shortname
  end
end
