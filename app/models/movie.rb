class Movie < ActiveRecord::Base
  has_and_belongs_to_many :genres
  has_and_belongs_to_many :countries
  has_and_belongs_to_many :languages
end
