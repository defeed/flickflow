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
  
  def self.fetch(imdb_id)
    fetcher = MovieFetcher.new imdb_id
    fetcher.fetch_all
  end
end
