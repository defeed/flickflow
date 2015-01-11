class Country < ActiveRecord::Base
  include FriendlyId
  friendly_id :name

  has_and_belongs_to_many :movies
  has_many :releases
end

# == Schema Information
#
# Table name: countries
#
#  id         :integer          not null, primary key
#  code       :string
#  name       :string
#  slug       :string
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_countries_on_code  (code) UNIQUE
#  index_countries_on_name  (name) UNIQUE
#  index_countries_on_slug  (slug) UNIQUE
#
