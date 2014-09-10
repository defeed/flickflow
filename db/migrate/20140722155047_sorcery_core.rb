class SorceryCore < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :username
      t.string :email
      t.string :crypted_password
      t.string :salt
      t.string :slug
      t.uuid :uuid

      t.timestamps
    end

    add_index :users, :email
    add_index :users, :username, unique: true
    add_index :users, :slug, unique: true
  end
end
