class RenameActiveToBiddable < ActiveRecord::Migration[4.2]
  def self.up
    rename_column :reqs, :active, :biddable
  end

  def self.down
    rename_column :reqs, :biddable, :active
  end
end
