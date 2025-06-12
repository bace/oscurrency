class RemoveBlogCommentCounterCache < ActiveRecord::Migration[4.2]
  def self.up
    remove_column :posts, :blog_post_comments_count
  end

  def self.down
    add_column :posts, :blog_post_comments_count, :integer, :default => 0,
                       :null => false
  end
end
