class AddPhonePeople < ActiveRecord::Migration[4.2]
  def self.up
    add_column :people, :phone, :string
  end

  def self.down
    remove_column :people, :phone
  end
end
