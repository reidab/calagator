class CreateReservations < ActiveRecord::Migration
  def self.up
    create_table :reservations do |t|
      t.integer :user_id
      t.integer :event_id
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :reservations
  end
end
