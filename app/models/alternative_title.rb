class AlternativeTitle < ActiveRecord::Base
  belongs_to :movie
end

# == Schema Information
#
# Table name: alternative_titles
#
#  id         :integer          not null, primary key
#  movie_id   :integer
#  title      :string
#  comment    :string
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_alternative_titles_on_movie_id_and_title  (movie_id,title)
#  index_alternative_titles_on_title               (title)
#
