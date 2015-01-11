class MovieFetcher
  def initialize(imdb_id)
    @imdb = Spotlite::Movie.new(imdb_id)
    @movie = Movie.find_or_create_by(imdb_id: imdb_id)
  end

  def fetch_general_info
    rotten = RottenMovie.find(imdb: @movie.imdb_id)

    @movie.title                  = @imdb.title
    @movie.original_title         = @imdb.original_title
    @movie.sort_title             = Movie.sort_title @movie.title
    @movie.year                   = @imdb.year
    @movie.imdb_rating            = @imdb.rating
    @movie.imdb_rating_count      = @imdb.votes
    @movie.metacritic_rating      = @imdb.metascore
    @movie.rotten_critics_rating  = rotten.ratings.critics_score unless rotten.error
    @movie.rotten_audience_rating = rotten.ratings.audience_score unless rotten.error
    @movie.runtime                = @imdb.runtime
    @movie.description            = @imdb.description
    @movie.storyline              = @imdb.storyline
    @movie.mpaa_rating            = @imdb.content_rating

    @movie.genres = []
    @imdb.genres.each do |genre|
      @movie.genres << Genre.find_or_create_by(name: genre)
    end

    @movie.countries = []
    @imdb.countries.each do |country|
      @movie.countries << Country.find_or_create_by(code: country[:code], name: country[:name])
    end

    @movie.languages = []
    @imdb.languages.each do |language|
      @movie.languages << Language.find_or_create_by(code: language[:code], name: language[:name])
    end

    @movie.save

    Delayed::Job.enqueue ImageFetchJob.new(@movie.imdb_id, :poster, @imdb.poster_url)
  end

  def fetch_people
    @movie.participations = []

    @imdb.cast.each do |actor|
      person = Person.find_or_create_from actor
      @movie.participations.actor.create(person: person, credit: actor.credits_text)
    end

    @imdb.stars.each do |star|
      person = Person.find_or_create_from star
      @movie.participations.star.create(person: person)
    end

    @imdb.directors.each do |director|
      person = Person.find_or_create_from director
      @movie.participations.director.create(person: person, credit: director.credits_text)
    end

    @imdb.writers.each do |writer|
      person = Person.find_or_create_from writer
      @movie.participations.writer.create(person: person, credit: writer.credits_text)
    end

    @imdb.producers.each do |producer|
      person = Person.find_or_create_from producer
      @movie.participations.producer.create(person: person, credit: producer.credits_text)
    end
  end

  def fetch_keywords
    @movie.keywords = []
    @imdb.keywords.each do |keyword|
      @movie.keywords << Keyword.find_or_create_by(name: keyword)
    end
  end

  def fetch_release_info
    @movie.released_on = nil
    @movie.releases = []
    @movie.released_on = @imdb.release_date
    @movie.save

    @imdb.release_dates.each do |release|
      country = Country.find_or_create_by(code: release[:code], name: release[:region])
      @movie.releases.create(country: country, released_on: release[:date], comment: release[:comment])
    end

    @movie.alternative_titles = []
    @imdb.alternative_titles.each do |aka|
      @movie.alternative_titles.create(title: aka[:title], comment: aka[:comment])
    end
  end

  def fetch_backdrops
    tmdb_movie = Tmdb::Find.imdb_id("tt#{@movie.imdb_id}").movie_results.first

    unless tmdb_movie.nil? || tmdb_movie.backdrop_path.nil?
      backdrop_url = 'http://image.tmdb.org/t/p/original' + tmdb_movie.backdrop_path
      Delayed::Job.enqueue ImageFetchJob.new(@movie.imdb_id, :backdrop, backdrop_url)
    end
  end

  def fetch_videos
    @movie.videos = []

    tmdb_movie = Tmdb::Find.imdb_id("tt#{@movie.imdb_id}").movie_results.first

    unless tmdb_movie.nil?
      videos = Tmdb::Movie.trailers(tmdb_movie.id).youtube

      videos.each do |video|
        @movie.videos.create(kind: video.type, title: video.name, youtube_id: video.source)
      end
    end
  end

  def fetch_recommended_movies
    @movie.recommendations = []

    @imdb.recommended_movies.each do |recommended_movie|
      other_movie = Movie.find_or_create_by(imdb_id: recommended_movie.imdb_id)
      @movie.recommendations.create(other_movie_id: other_movie.id)
      other_movie.fetch
    end
  end

  def fetch_critic_reviews
    @movie.critic_reviews = []

    @imdb.critic_reviews.each do |review|
      @movie.critic_reviews.create(author: review[:author], publisher: review[:source], excerpt: review[:excerpt], rating: review[:score])
    end
  end

  def fetch_trivia
    @movie.trivia = []

    @imdb.trivia.each do |trivium|
      @movie.trivia.create(text: trivium)
    end
  end
end
