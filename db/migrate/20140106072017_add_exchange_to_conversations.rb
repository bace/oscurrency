class AddExchangeToConversations < ActiveRecord::Migration[4.2]
  def change
    add_column :conversations, :exchange_id, :integer
  end
end
