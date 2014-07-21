# == Schema Information
#
# Table name: alternative_titles
#
#  id         :integer          not null, primary key
#  movie_id   :string(255)
#  title      :string(255)
#  comment    :string(255)
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_alternative_titles_on_movie_id_and_title  (movie_id,title)
#

class AlternativeTitle < ActiveRecord::Base
  belongs_to :movie
end
