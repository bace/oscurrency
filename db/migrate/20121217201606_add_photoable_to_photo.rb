class AddPhotoableToPhoto < ActiveRecord::Migration[4.2]
  def self.up
    add_column :photos, :photoable_id, :integer
    add_column :photos, :photoable_type, :string
  end
end
