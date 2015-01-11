class Genre < ActiveRecord::Base
  include FriendlyId
  friendly_id :name

  has_and_belongs_to_many :movies
end

# == Schema Information
#
# Table name: genres
#
#  id         :integer          not null, primary key
#  name       :string
#  slug       :string
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_genres_on_name  (name) UNIQUE
#  index_genres_on_slug  (slug) UNIQUE
#
