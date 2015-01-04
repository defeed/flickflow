class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :code
      t.string :name
      t.string :slug

      t.timestamps
    end

    add_index :languages, :name, unique: true
    add_index :languages, :code, unique: true
    add_index :languages, :slug, unique: true
  end
end
