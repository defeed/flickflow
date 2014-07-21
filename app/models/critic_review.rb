# == Schema Information
#
# Table name: critic_reviews
#
#  id         :integer          not null, primary key
#  movie_id   :integer
#  author     :string(255)
#  publisher  :string(255)
#  excerpt    :text
#  rating     :integer
#  created_at :datetime
#  updated_at :datetime
#

class CriticReview < ActiveRecord::Base
  belongs_to :movie
end
