class RemoveSessionColumn < ActiveRecord::Migration[4.2]
  def self.up
    remove_column :page_views, :session
  end

  def self.down
    add_column :page_views, :session, :string,     :limit => 32
  end
end
