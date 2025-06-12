class AddInvalidatedAtToCapabilities < ActiveRecord::Migration[4.2]
  def self.up
    add_column :capabilities, :invalidated_at, :timestamp
  end

  def self.down
    remove_column :capabilities, :invalidated_at
  end
end
