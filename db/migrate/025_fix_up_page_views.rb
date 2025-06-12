class FixUpPageViews < ActiveRecord::Migration[4.2]
  def self.up
    remove_column :page_views, :user_id
    add_column    :page_views, :person_id, :integer
    add_index     :page_views, [:person_id, :created_at]
  end

  def self.down
    add_column    :page_views, :user_id, :integer
    remove_index  :page_views, [:person_id, :created_at]
    remove_column :page_views, :person_id
  end
end
