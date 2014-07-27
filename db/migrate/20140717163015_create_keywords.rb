class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords do |t|
      t.string :name
      t.string :slug

      t.timestamps
    end
    
    add_index :keywords, :name, unique: true
    add_index :keywords, :slug, unique: true
  end
end
