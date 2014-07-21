class CreateCriticReviews < ActiveRecord::Migration
  def change
    create_table :critic_reviews do |t|
      t.integer :movie_id
      t.string :author
      t.string :publisher
      t.text :excerpt
      t.integer :rating

      t.timestamps
    end
  end
end
