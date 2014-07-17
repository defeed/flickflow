class CreateCountriesMoviesJoinTable < ActiveRecord::Migration
  def change
    create_join_table :countries, :movies do |t|
      t.index [:country_id, :movie_id]
    end
  end
end
