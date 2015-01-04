class Movie < ActiveRecord::Base
  include FriendlyId
  friendly_id :slug_candidates

  validates :imdb_id, presence: true

  has_and_belongs_to_many :genres
  has_and_belongs_to_many :countries
  has_and_belongs_to_many :languages
  has_and_belongs_to_many :keywords

  has_many :releases, dependent: :destroy
  has_many :alternative_titles, dependent: :destroy
  has_many :trivia, dependent: :destroy
  has_many :critic_reviews, dependent: :destroy

  has_many :actorships, -> { where job: Participation.jobs[:actor] },
           class_name: 'Participation'
  has_many :starships, -> { where job: Participation.jobs[:star] },
           class_name: 'Participation'
  has_many :directorships, -> { where job: Participation.jobs[:director] },
           class_name: 'Participation'
  has_many :writerships, -> { where job: Participation.jobs[:writer] },
           class_name: 'Participation'
  has_many :producerships, -> { where job: Participation.jobs[:producer] },
           class_name: 'Participation'

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

  has_many :posters, as: :imageable, dependent: :destroy
  has_one :primary_poster, -> { where is_primary: true },
          class_name: 'Poster', as: :imageable
  has_many :stills, as: :imageable, dependent: :destroy
  has_many :backdrops, as: :imageable, dependent: :destroy
  has_one :primary_backdrop, -> { where is_primary: true },
          class_name: 'Backdrop', as: :imageable
  has_many :videos, dependent: :destroy
  has_many :trailers, -> { where kind: 'Trailer' }, class_name: 'Video'
  has_many :fetches, as: :fetchable, dependent: :destroy

  after_create :set_uuid
  after_create :fetch

  scope :released,   -> { where('released_on <= ?', Date.today) }
  scope :with_title, -> { where('title IS NOT ?', nil) }
  scope :with_pop_index, -> { where('pop_index IS NOT ?', nil) }
  scope :with_poster, -> { joins(:posters) }
  scope :without_title, -> { where('title IS ?', nil) }

  def self.fetch(imdb_id, page = nil, force = false)
    imdb = Spotlite::Movie.new imdb_id
    Movie.find_or_create_by(imdb_id: imdb.imdb_id)
    Delayed::Job.enqueue MovieFetcher.new(imdb.imdb_id, page, force)
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

  def fetch
    Delayed::Job.enqueue MovieFetchJob.new(imdb_id)
    Delayed::Job.enqueue PeopleFetchJob.new(imdb_id)
    Delayed::Job.enqueue ReleasesFetchJob.new(imdb_id)
    Delayed::Job.enqueue BackdropsFetchJob.new(imdb_id)
    Delayed::Job.enqueue VideosFetchJob.new(imdb_id)
    Delayed::Job.enqueue KeywordsFetchJob.new(imdb_id)
    Delayed::Job.enqueue CriticReviewsFetchJob.new(imdb_id)
    Delayed::Job.enqueue TriviaFetchJob.new(imdb_id)
  end

  def fetch_recommended_movies
    Delayed::Job.enqueue RecommendationsFetchJob.new(imdb_id)
  end

  def released?
    released_on? && released_on <= Date.today
  end

  def toggle_in_list(user, list)
    list.toggle_entry user, self
  end

  def slug_candidates
    [
      :title,
      [:title, :year],
      [:imdb_id]
    ]
  end

  def should_generate_new_friendly_id?
    title_changed? || year_changed? || super
  end

  private

  def set_uuid
    update(uuid: SecureRandom.uuid)
  end
end

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
#  pop_index              :integer
#  slug                   :string(255)
#  uuid                   :uuid
#  created_at             :datetime
#  updated_at             :datetime
#
# Indexes
#
#  index_movies_on_imdb_id    (imdb_id) UNIQUE
#  index_movies_on_pop_index  (pop_index)
#  index_movies_on_slug       (slug) UNIQUE
#  index_movies_on_title      (title)
#
