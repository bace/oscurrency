class RemovePersonIdAndGroupIdFromPhotos < ActiveRecord::Migration[4.2]
  def up
    remove_column :photos, :person_id
    remove_column :photos, :group_id
  end

  def down
    add_column :photos, :group_id, :integer
    add_column :photos, :person_id, :integer
  end
end
