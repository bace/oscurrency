class AddPictureToPhotos < ActiveRecord::Migration[4.2]
  def change
    add_column :photos, :picture, :string
  end
end
