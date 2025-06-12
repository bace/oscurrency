class AddLanguagePeople < ActiveRecord::Migration[4.2]
  def self.up
    add_column :people, :language, :string
  end

  def self.down
    remove_column :people, :language
  end
end
