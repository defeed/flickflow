class Video < ActiveRecord::Base
  belongs_to :movie
end

# == Schema Information
#
# Table name: videos
#
#  id         :integer          not null, primary key
#  movie_id   :integer
#  kind       :string
#  title      :string
#  youtube_id :string
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_videos_on_movie_id  (movie_id)
#
