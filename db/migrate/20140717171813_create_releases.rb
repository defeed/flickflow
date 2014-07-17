class CreateReleases < ActiveRecord::Migration
  def change
    create_table :releases do |t|
      t.integer :country_id
      t.integer :movie_id
      t.date :released_on
      t.string :comment

      t.timestamps
    end
    
    add_index :releases, [:country_id, :movie_id]
  end
end
