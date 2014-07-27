# == Schema Information
#
# Table name: languages
#
#  id         :integer          not null, primary key
#  code       :string(255)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  slug       :string(255)
#
# Indexes
#
#  index_languages_on_slug  (slug) UNIQUE
#

class Language < ActiveRecord::Base
  include FriendlyId
  friendly_id :name
  
  has_and_belongs_to_many :movies
end
