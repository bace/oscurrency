class AddWebSiteUrlToProfile < ActiveRecord::Migration[4.2]
  def self.up
    add_column :people, :web_site_url, :string
  end

  def self.down
    remove_column :people, :web_site_url
  end
end
