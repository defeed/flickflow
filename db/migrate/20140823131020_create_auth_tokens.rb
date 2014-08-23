class CreateAuthTokens < ActiveRecord::Migration
  def change
    create_table :auth_tokens do |t|
      t.string :token,    null: false
      t.integer :user_id

      t.timestamps
    end
    
    add_index :auth_tokens, :token, unique: true
  end
end
