class CreateParticipations < ActiveRecord::Migration
  def change
    create_table :participations do |t|
      t.integer :movie_id
      t.integer :person_id
      t.integer :job
      t.string :credit

      t.timestamps
    end
    
    add_index :participations, [:movie_id, :person_id]
    add_index :participations, [:movie_id, :person_id, :job, :credit], unique: true, name: 'participations_index'
  end
end
