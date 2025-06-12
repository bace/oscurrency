class AddGroupIdToOauthTokens < ActiveRecord::Migration[4.2]
  def self.up
    add_column :oauth_tokens, :group_id, :integer
  end

  def self.down
    remove_column :oauth_tokens, :group_id
  end
end
