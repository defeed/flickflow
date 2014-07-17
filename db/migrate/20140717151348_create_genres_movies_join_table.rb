class CreateGenresMoviesJoinTable < ActiveRecord::Migration
  def change
    create_join_table :genres, :movies do |t|
      t.index [:genre_id, :movie_id]
    end
  end
end
