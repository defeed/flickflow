class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.integer :movie_id
      t.integer :other_movie_id
    end
    
    add_index :recommendations, [:movie_id, :other_movie_id], unique: true
    add_index :recommendations, [:other_movie_id, :movie_id], unique: true
  end
end
