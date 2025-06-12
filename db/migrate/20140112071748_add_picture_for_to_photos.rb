class AddPictureForToPhotos < ActiveRecord::Migration[4.2]
  def change
    add_column :photos, :picture_for, :string
  end
end
