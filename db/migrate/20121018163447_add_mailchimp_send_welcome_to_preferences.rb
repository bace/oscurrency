class AddMailchimpSendWelcomeToPreferences < ActiveRecord::Migration[4.2]
  def change
    add_column :preferences, :mailchimp_send_welcome, :boolean, :default => true
  end
end
