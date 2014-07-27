class SorceryCore < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :username,         :null => false
      t.string :email,            :null => false
      t.string :crypted_password, :null => false
      t.string :salt,             :null => false
      t.string :slug

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :username, unique: true
    add_index :users, :slug, unique: true
  end
end
