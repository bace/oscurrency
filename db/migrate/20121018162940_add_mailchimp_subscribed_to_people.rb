class AddMailchimpSubscribedToPeople < ActiveRecord::Migration[4.2]
  def change
    add_column :people, :mailchimp_subscribed, :boolean, :default => false
  end
end
