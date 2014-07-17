class CreateLanguagesMoviesJoinTable < ActiveRecord::Migration
  def change
    create_join_table :languages, :movies do |t|
      t.index [:language_id, :movie_id]
    end
  end
end
