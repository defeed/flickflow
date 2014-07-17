class AddIndexOnTitleAndImdbidToMovies < ActiveRecord::Migration
  def change
    add_index :movies, :imdb_id, unique: true
    add_index :movies, :title
  end
end
