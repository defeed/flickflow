class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.references :user
      t.integer :list_type
      t.string :name
      t.boolean :is_private, default: false
      t.string :slug
      
      t.timestamps
    end
    
    add_index :lists, :name
    add_index :lists, [:user_id, :name]
    add_index :lists, [:user_id, :list_type]
    add_index :lists, :slug
  end
end
