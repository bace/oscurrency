class CreateBroadcastEmails < ActiveRecord::Migration[4.2]
  def self.up
    create_table :broadcast_emails do |t|
      t.string :subject
      t.text :message

      t.timestamps
    end
  end

  def self.down
    drop_table :broadcast_emails
  end
end
