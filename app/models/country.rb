# == Schema Information
#
# Table name: countries
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
#  index_countries_on_slug  (slug) UNIQUE
#

class Country < ActiveRecord::Base
  include FriendlyId
  friendly_id :name
  
  has_and_belongs_to_many :movies
  has_many :releases
end
