class CreateKeywordsMoviesJoinTable < ActiveRecord::Migration
  def change
    create_join_table :keywords, :movies do |t|
      t.index [:movie_id, :keyword_id]
      t.index [:keyword_id, :movie_id]
    end
  end
end
