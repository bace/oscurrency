class AddEnableForumToGroups < ActiveRecord::Migration[4.2]
  def change
    add_column :groups, :enable_forum, :boolean, :default => true
  end
end
