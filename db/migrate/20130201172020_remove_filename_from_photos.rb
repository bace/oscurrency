class RemoveFilenameFromPhotos < ActiveRecord::Migration[4.2]
  def up
    remove_column :photos, :filename
  end

  def down
    add_column :photos, :filename, :string
  end
end
