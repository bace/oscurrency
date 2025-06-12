class AddTalkableToConversation < ActiveRecord::Migration[4.2]
  def change
    add_column :conversations, :talkable_id, :integer
    add_column :conversations, :talkable_type, :string
  end
end
