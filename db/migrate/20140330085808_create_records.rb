class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.integer :divece_id
      t.float :temperature
      t.float :pm25
      t.float :formaldehyde
      t.time :detect_time

      t.timestamps
    end
  end
end
