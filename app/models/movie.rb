class Movie < ActiveRecord::Base
  has_and_belongs_to_many :genres
  has_and_belongs_to_many :countries
  has_and_belongs_to_many :languages
  has_and_belongs_to_many :keywords
  
  has_many :releases, dependent: :destroy
  has_many :alternative_titles, dependent: :destroy
  
  has_many :actorships,    -> { where job: Participation.jobs[:actor] },    class_name: 'Participation'
  has_many :starships,     -> { where job: Participation.jobs[:star] },     class_name: 'Participation'
  has_many :directorships, -> { where job: Participation.jobs[:director] }, class_name: 'Participation'
  has_many :writerships,   -> { where job: Participation.jobs[:writer] },   class_name: 'Participation'
  has_many :producerships, -> { where job: Participation.jobs[:producer] }, class_name: 'Participation'
  
  has_many :participations, dependent: :destroy
  has_many :directors, through: :directorships, source: :person
  has_many :writers,   through: :writerships,   source: :person
  has_many :producers, through: :producerships, source: :person
  has_many :actors,    through: :actorships,    source: :person
  has_many :stars,     through: :starships,     source: :person
  
  has_many :recommendations, dependent: :destroy
  has_many :recommended_movies, through: :recommendations, source: :movie
  
  scope :released,  -> { where('released_on <= ?', Date.today) }
  scope :fetched,   -> { where('title IS NOT ?', nil) }
  scope :unfetched, -> { where('title IS ?', nil) }
  
  def self.fetch(imdb_id)
    fetcher = MovieFetcher.new imdb_id
    fetcher.fetch_all
  end
  
  def self.search_on_imdb(params = {})
    Spotlite::Movie.search(params)
  end
  
  def self.find_on_imdb(query)
    Spotlite::Movie.find(query)
  end
  
  def fetch
    Movie.fetch self.imdb_id
  end
  
  def released?
    released_on? && released_on <= Date.today
  end
end
