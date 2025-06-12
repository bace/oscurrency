class AddAcceptAgreementToPeople < ActiveRecord::Migration[4.2]
  def self.up
    add_column :people, :accept_agreement, :boolean, :default => false
  end

  def self.down
    remove_column :people, :accept_agreement
  end
end
