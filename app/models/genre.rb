# == Schema Information
#
# Table name: genres
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  slug       :string(255)
#
# Indexes
#
#  index_genres_on_slug  (slug) UNIQUE
#

class Genre < ActiveRecord::Base
  include FriendlyId
  friendly_id :name
  
  has_and_belongs_to_many :movies
end
