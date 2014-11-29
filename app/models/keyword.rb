class Keyword < ActiveRecord::Base
  include FriendlyId
  friendly_id :name

  has_and_belongs_to_many :movies
end

# == Schema Information
#
# Table name: keywords
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  slug       :string(255)
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_keywords_on_name  (name) UNIQUE
#  index_keywords_on_slug  (slug) UNIQUE
#
