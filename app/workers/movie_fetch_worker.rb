class MovieFetchWorker
  include Sidekiq::Worker

  def perform(imdb_id, force = false)
    movie = Movie.find_by(imdb_id: imdb_id)
    return unless fetch_required?(movie, force)

    imdb = Spotlite::Movie.new(imdb_id)
    rotten = RottenMovie.find(imdb: imdb_id)

    movie.title                  = imdb.title
    movie.original_title         = imdb.original_title
    movie.sort_title             = Movie.sort_title movie.title
    movie.year                   = imdb.year
    movie.imdb_rating            = imdb.rating
    movie.imdb_rating_count      = imdb.votes
    movie.metacritic_rating      = imdb.metascore
    movie.rotten_critics_rating  = rotten.ratings.critics_score unless rotten.error
    movie.rotten_audience_rating = rotten.ratings.audience_score unless rotten.error
    movie.runtime                = imdb.runtime
    movie.description            = imdb.description
    movie.storyline              = imdb.storyline
    movie.mpaa_rating            = imdb.content_rating

    movie.genres = []
    imdb.genres.each do |genre|
      movie.genres << Genre.find_or_create_by(name: genre)
    end

    movie.countries = []
    imdb.countries.each do |country|
      movie.countries << Country.find_or_create_by(code: country[:code], name: country[:name])
    end

    movie.languages = []
    imdb.languages.each do |language|
      movie.languages << Language.find_or_create_by(code: language[:code], name: language[:name])
    end

    has_data = [movie.title, movie.original_title, movie.year, movie.imdb_rating, movie.imdb_rating_count, movie.runtime, movie.description, movie.storyline, movie.mpaa_rating].any? &:present?
    log_fetch(movie, imdb.response, has_data)

    movie.save
  end

  private

    def fetch_required?(movie, force)
      return true if movie.fetches.none?
      return true if force
      Time.now.utc - movie.fetches.last.created_at > fetch_delay(movie)
    end

    def fetch_delay(movie)
      return 1.week unless movie.has_release_date?

      days_difference = (Date.today - movie.released_on).abs.to_i

      if days_difference > 365
        2.weeks
      elsif days_difference > 180
        1.week
      elsif days_difference > 90
        5.days
      elsif days_difference > 30
        3.days
      elsif days_difference > 7
        1.day
      else
        6.hours
      end
    end

    def log_fetch(movie, response, has_data)
      movie.fetches.build(response_code: response[:code], response_message: response[:message], has_data: has_data)
    end
end
