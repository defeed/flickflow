class Movie < ActiveRecord::Base
  has_and_belongs_to_many :genres
  has_and_belongs_to_many :countries
  has_and_belongs_to_many :languages
  has_and_belongs_to_many :keywords
  
  has_many :releases, dependent: :destroy
  
  def self.fetch(imdb_id)
    fetcher = MovieFetcher.new imdb_id
    fetcher.fetch_all
  end
end
