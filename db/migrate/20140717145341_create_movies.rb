class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :imdb_id
      t.string :title
      t.string :original_title
      t.string :sort_title
      t.integer :year
      t.date :released_on
      t.float :imdb_rating
      t.integer :imdb_rating_count
      t.integer :rotten_critics_rating
      t.integer :rotten_audience_rating
      t.integer :metacritic_rating
      t.string :mpaa_rating
      t.string :description, limit: 1000
      t.text :storyline
      t.integer :runtime
      t.integer :pop_index
      t.string :slug
      t.uuid :uuid

      t.timestamps
    end

    add_index :movies, :slug, unique: true
    add_index :movies, :pop_index
  end
end
