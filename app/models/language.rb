class Language < ActiveRecord::Base
  include FriendlyId
  friendly_id :name

  has_and_belongs_to_many :movies
end

# == Schema Information
#
# Table name: languages
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
#  index_languages_on_code  (code) UNIQUE
#  index_languages_on_name  (name) UNIQUE
#  index_languages_on_slug  (slug) UNIQUE
#
