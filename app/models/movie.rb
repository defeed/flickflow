# == Schema Information
#
# Table name: movies
#
#  id                     :integer          not null, primary key
#  imdb_id                :string(255)
#  title                  :string(255)
#  original_title         :string(255)
#  sort_title             :string(255)
#  year                   :integer
#  released_on            :date
#  imdb_rating            :float
#  imdb_rating_count      :integer
#  rotten_critics_rating  :integer
#  rotten_audience_rating :integer
#  metacritic_rating      :integer
#  mpaa_rating            :string(255)
#  description            :string(1000)
#  storyline              :text
#  runtime                :integer
#  poster_url             :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  slug                   :string(255)
#
# Indexes
#
#  index_movies_on_imdb_id  (imdb_id) UNIQUE
#  index_movies_on_slug     (slug) UNIQUE
#  index_movies_on_title    (title)
#

class Movie < ActiveRecord::Base
  include FriendlyId
  friendly_id :slug_candicates
  
  # # # # # # # #
  # Associations
  # # # # # # # #
  has_and_belongs_to_many :genres
  has_and_belongs_to_many :countries
  has_and_belongs_to_many :languages
  has_and_belongs_to_many :keywords
  
  has_many :releases, dependent: :destroy
  has_many :alternative_titles, dependent: :destroy
  has_many :trivia, dependent: :destroy
  has_many :critic_reviews, dependent: :destroy
  
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
  
  has_many :list_entries, as: :listable, dependent: :destroy
  has_many :lists, through: :list_entries
  
  # # # # #
  # Scopes
  # # # # #
  scope :released,  -> { where('released_on <= ?', Date.today) }
  scope :fetched,   -> { where('title IS NOT ?', nil) }
  scope :unfetched, -> { where('title IS ?', nil) }
  
  # # # # # # # #
  # Class Methods
  # # # # # # # #
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
  
  def self.sort_title(title)
    return unless title
    title.gsub(/^(The|An|A)\s+/, '').downcase
  end
  
  # # # # # # # # # #
  # Instance Methods
  # # # # # # # # # #
  def fetch
    Movie.fetch self.imdb_id
  end
  
  def fetch_recommended_movies
    MovieFetcher.new(self.imdb_id).fetch_recommended_movies
  end
  
  def released?
    released_on? && released_on <= Date.today
  end
  
  def toggle_in_list(user, list)
    list.toggle_entry user, self
  end
  
  def slug_candicates
    [
      :title,
      [:title, :year],
      [:imdb_id]
    ]
  end
  
  def should_generate_new_friendly_id?
    title_changed? || year_changed? || super
  end
end
