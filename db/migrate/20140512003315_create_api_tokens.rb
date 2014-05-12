class CreateApiTokens < ActiveRecord::Migration
  def change
    create_table :api_tokens do |t|
      t.integer :user_id
      t.string :api_token
      t.datetime :expire_time
    end
  end
end
