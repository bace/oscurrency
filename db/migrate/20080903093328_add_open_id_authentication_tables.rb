class AddOpenIdAuthenticationTables < ActiveRecord::Migration[4.2]
  def self.up
    create_table :open_id_authentication_associations, :force => true do |t|
      t.integer :issued, :lifetime
      t.string :handle, :assoc_type
      t.binary :server_url, :secret
    end

    create_table :open_id_authentication_nonces, :force => true do |t|
      t.integer :timestamp, :null => false
      t.string :server_url, :null => true
      t.string :salt, :null => false
    end

    add_column :people, :identity_url, :string
  end

  def self.down
    remove_column :people, :identity_url
    drop_table :open_id_authentication_associations
    drop_table :open_id_authentication_nonces
  end
end
