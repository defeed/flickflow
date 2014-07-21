class CreateTrivia < ActiveRecord::Migration
  def change
    create_table :trivia do |t|
      t.integer :movie_id
      t.text :text

      t.timestamps
    end
  end
end
