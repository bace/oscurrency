class AddAgreementLabelToPreferences < ActiveRecord::Migration[6.1]
  def change
    add_column :preferences, :agreement_label, :string, default: ''
  end
end
