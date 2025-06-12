class AddActiveToReqsAgain < ActiveRecord::Migration[4.2]
  def self.up
    add_column :reqs, :active, :boolean, :default => false
  end

  def self.down
    remove_column :reqs, :active
  end
end
