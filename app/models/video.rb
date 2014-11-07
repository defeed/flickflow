# == Schema Information
#
# Table name: videos
#
#  id         :integer          not null, primary key
#  movie_id   :integer
#  kind       :string(255)
#  title      :string(255)
#  youtube_id :string(255)
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_videos_on_movie_id  (movie_id)
#

class Video < ActiveRecord::Base
  belongs_to :movie
end
