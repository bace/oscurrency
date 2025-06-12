class RemoveAcceptAgreementFromPeople < ActiveRecord::Migration[4.2]
  def self.up
    remove_column :people, :accept_agreement
  end

  def self.down
    add_column :people, :accept_agreement, :boolean, :default => true
  end
end
