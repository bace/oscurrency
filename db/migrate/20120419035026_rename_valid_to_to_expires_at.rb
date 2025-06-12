class RenameValidToToExpiresAt < ActiveRecord::Migration[4.2]
  def up
    rename_column :oauth_tokens, :valid_to, :expires_at
  end

  def down
    rename_column :oauth_tokens, :expires_at, :valid_to
  end
end
