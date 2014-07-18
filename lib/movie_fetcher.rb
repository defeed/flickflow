class MovieFetcher
  def initialize(imdb_id)
    @imdb_id = imdb_id
  end
  
  def fetch_all
    fetch_basic_info
    fetch_keywords
    fetch_releases
  end
  
  def fetch_basic_info
    imdb = Spotlite::Movie.new(@imdb_id)
    movie = Movie.find_or_create_by(imdb_id: imdb.imdb_id)
    rotten = RottenMovie.find(imdb: imdb.imdb_id)
    
    movie.imdb_id                = imdb.imdb_id
    movie.title                  = imdb.title
    movie.original_title         = imdb.original_title
    movie.year                   = imdb.year
    movie.imdb_rating            = imdb.rating
    movie.imdb_votes_count       = imdb.votes
    movie.metacritic_rating      = imdb.metascore
    movie.rotten_critics_rating  = rotten.ratings.critics_score unless rotten.error
    movie.rotten_audience_rating = rotten.ratings.audience_score unless rotten.error
    movie.runtime                = imdb.runtime
    movie.description            = imdb.description
    movie.storyline              = imdb.storyline
    movie.mpaa_rating            = imdb.content_rating
    movie.poster_url             = imdb.poster_url
    
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
    
    movie.save
  end
    
  def fetch_keywords
    imdb = Spotlite::Movie.new(@imdb_id)
    movie = Movie.find_or_create_by(imdb_id: imdb.imdb_id)
    
    movie.keywords = []
    imdb.keywords.each do |keyword|
      movie.keywords << Keyword.find_or_create_by(name: keyword)
    end
    
    movie.save
  end
  handle_asynchronously :fetch_keywords, queue: 'keywords'
  
  def fetch_releases
    imdb = Spotlite::Movie.new(@imdb_id)
    movie = Movie.find_or_create_by(imdb_id: imdb.imdb_id)
    
    movie.released_on = nil
    movie.releases = []
    movie.released_on = imdb.release_date
    imdb.release_dates.each do |release|
      country = Country.find_or_create_by(code: release[:code], name: release[:region])
      movie.releases << Release.find_or_create_by(country: country, released_on: release[:date], comment: release[:comment])
    end
    
    movie.save
  end
  handle_asynchronously :fetch_releases, queue: 'releases'
end
