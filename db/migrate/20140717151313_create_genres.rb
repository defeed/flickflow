class CreateGenres < ActiveRecord::Migration
  def change
    create_table :genres do |t|
      t.string :name
      t.string :slug

      t.timestamps
    end

    add_index :genres, :name, unique: true
    add_index :genres, :slug, unique: true
  end
end
