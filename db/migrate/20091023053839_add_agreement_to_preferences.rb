class AddAgreementToPreferences < ActiveRecord::Migration[4.2]
  def self.up
    add_column :preferences, :agreement, :text
  end

  def self.down
    remove_column :preferences, :agreement
  end
end
