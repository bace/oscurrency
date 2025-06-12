class AddBlogFeedUrlPreferences < ActiveRecord::Migration[4.2]
  def self.up
    add_column :preferences, :blog_feed_url, :string
  end

  def self.down
    remove_column :preferences, :blog_feed_url
  end
end
