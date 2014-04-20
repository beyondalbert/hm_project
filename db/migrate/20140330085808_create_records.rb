class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.integer :device_id
      t.float :temperature
      t.float :pm25
      t.float :formaldehyde
      t.datetime :detect_time

      t.timestamps
    end
  end
end
