class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :serial_num
      t.string :alias
      t.string :address
      t.integer :user_id

      t.timestamps
    end
  end
end
