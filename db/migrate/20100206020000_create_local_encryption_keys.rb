class CreateLocalEncryptionKeys < ActiveRecord::Migration
  include Crypto

  # temporarily create this class, to be removed in next migration.
  class LocalEncryptionKey < ActiveRecord::Base
  end

  def self.up

    begin
# I can't get the rescue to work, so comment this out
#      drop_table :local_encryption_keys
    rescue
    end

    create_table :local_encryption_keys do |t|
      t.text :rsa_private_key
      t.text :rsa_public_key
      t.text :session_secret
    end

    # RSA keys for user authentication
    # XXX hack! until authentication is replaced, rsa keys are now going
    # into database instead of files for diskless deploy.
#    key = LocalEncryptionKey.create!

    # comment out this.
#    error "You need to hand-edit this migration to have the right RSA keys"

    # uncomment and set these
    # mt: no.  Do this by hand in the console.
#    key.rsa_public_key =
#    key.rsa_private_key = 
#    key.save!
  end

  def self.down
    drop_table :local_encryption_keys
  end
end
