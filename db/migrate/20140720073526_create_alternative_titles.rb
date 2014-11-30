class CreateAlternativeTitles < ActiveRecord::Migration
  def change
    create_table :alternative_titles do |t|
      t.integer :movie_id
      t.string :title
      t.string :comment

      t.timestamps
    end

    add_index :alternative_titles, [:movie_id, :title]
  end
end
