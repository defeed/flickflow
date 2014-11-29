class Trivium < ActiveRecord::Base
  belongs_to :movie
end

# == Schema Information
#
# Table name: trivia
#
#  id         :integer          not null, primary key
#  movie_id   :integer
#  text       :text
#  created_at :datetime
#  updated_at :datetime
#
