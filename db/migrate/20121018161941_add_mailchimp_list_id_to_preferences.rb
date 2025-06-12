class AddMailchimpListIdToPreferences < ActiveRecord::Migration[4.2]
  def change
    add_column :preferences, :mailchimp_list_id, :string
  end
end
