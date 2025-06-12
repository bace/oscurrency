class CreateAttendeesToEvents < ActiveRecord::Migration[4.2]
  def self.up
    create_table :event_attendees do |t|
      t.references :person
      t.references :event
    end
  end

  def self.down
    drop_table :event_attendees
  end
end
