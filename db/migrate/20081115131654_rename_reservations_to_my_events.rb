class RenameReservationsToMyEvents < ActiveRecord::Migration
  def self.up
    rename_table :reservations, :my_events
  end

  def self.down
    rename_table :my_events, :reservations
  end
end
