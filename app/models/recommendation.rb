# == Schema Information
#
# Table name: recommendations
#
#  id             :integer          not null, primary key
#  movie_id       :integer
#  other_movie_id :integer
#
# Indexes
#
#  index_recommendations_on_movie_id_and_other_movie_id  (movie_id,other_movie_id) UNIQUE
#  index_recommendations_on_other_movie_id_and_movie_id  (other_movie_id,movie_id) UNIQUE
#

class Recommendation < ActiveRecord::Base
  belongs_to :movie, foreign_key: :other_movie_id
  belongs_to :recommended_movie, class_name: 'Movie'
end
