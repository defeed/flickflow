class Recommendation < ActiveRecord::Base
  belongs_to :movie, foreign_key: :other_movie_id
  belongs_to :recommended_movie, class_name: 'Movie'
end
