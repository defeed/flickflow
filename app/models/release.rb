class Release < ActiveRecord::Base
  belongs_to :country
  belongs_to :movie
end

# == Schema Information
#
# Table name: releases
#
#  id          :integer          not null, primary key
#  country_id  :integer
#  movie_id    :integer
#  released_on :date
#  comment     :string
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_releases_on_country_id_and_movie_id  (country_id,movie_id)
#
