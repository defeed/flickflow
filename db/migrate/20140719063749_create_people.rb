class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :imdb_id
      t.string :name
      t.string :birth_name
      t.date :born_on
      t.date :died_on
      t.text :bio

      t.timestamps
    end
    
    add_index :people, :imdb_id, unique: true
    add_index :people, :name
  end
end
