class AddSentToBroadcastEmails < ActiveRecord::Migration[4.2]
  def self.up
    add_column :broadcast_emails, :sent, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :broadcast_emails, :sent
  end
end
