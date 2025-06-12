class AddAltSignupLinkToPreferences < ActiveRecord::Migration[4.2]
  def change
  	add_column :preferences, :alt_signup_link, :string
  end
end
