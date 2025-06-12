class AddPostsPerPageToPeople < ActiveRecord::Migration[4.2]
  def change
    add_column :people, :posts_per_page, :integer, :default => 25
  end
end
