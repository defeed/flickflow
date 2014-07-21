class MovieFetcher
  def initialize(imdb_id)
    @imdb_id = imdb_id
  end
  
  def fetch_all
    fetch_basic_info
    fetch_people
    fetch_release_info
    fetch_keywords
    fetch_trivia
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
    movie.imdb_rating_count      = imdb.votes
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
    
    movie.recommendations = []
    imdb.recommended_movies.each do |recommended_movie|
      other_movie = Movie.find_or_create_by(imdb_id: recommended_movie.imdb_id)
      movie.recommendations.build(other_movie_id: other_movie.id)
    end
    
    movie.save
  end
  
  def fetch_people
    imdb = Spotlite::Movie.new(@imdb_id)
    movie = Movie.find_or_create_by(imdb_id: imdb.imdb_id)
    
    movie.participations = []
    
    imdb.cast.each do |actor|
      person = Person.find_or_create_by(imdb_id: actor.imdb_id, name: actor.name)
      movie.participations.actor.create(person: person, credit: actor.credits_text)
    end
    
    imdb.stars.each do |star|
      person = Person.find_or_create_by(imdb_id: star.imdb_id, name: star.name)
      movie.participations.star.create(person: person)
    end
    
    imdb.directors.each do |director|
      person = Person.find_or_create_by(imdb_id: director.imdb_id, name: director.name)
      movie.participations.director.create(person: person, credit: director.credits_text)
    end
    
    imdb.writers.each do |writer|
      person = Person.find_or_create_by(imdb_id: writer.imdb_id, name: writer.name)
      movie.participations.writer.create(person: person, credit: writer.credits_text)
    end
    
    imdb.producers.each do |producer|
      person = Person.find_or_create_by(imdb_id: producer.imdb_id, name: producer.name)
      movie.participations.producer.create(person: person, credit: producer.credits_text)
    end
    
    movie.save
  end
  handle_asynchronously :fetch_people, queue: 'people'
    
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
  
  def fetch_release_info
    imdb = Spotlite::Movie.new(@imdb_id)
    movie = Movie.find_or_create_by(imdb_id: imdb.imdb_id)
    
    movie.released_on = nil
    movie.releases = []
    movie.released_on = imdb.release_date
    imdb.release_dates.each do |release|
      country = Country.find_or_create_by(code: release[:code], name: release[:region])
      movie.releases.create(country: country, released_on: release[:date], comment: release[:comment])
    end
    
    movie.alternative_titles = []
    imdb.alternative_titles.each do |aka|
      movie.alternative_titles.create(title: aka[:title], comment: aka[:comment])
    end
    
    movie.save
  end
  handle_asynchronously :fetch_release_info, queue: 'release_info'
  
  def fetch_trivia
    imdb = Spotlite::Movie.new(@imdb_id)
    movie = Movie.find_or_create_by(imdb_id: imdb.imdb_id)
    
    movie.trivia = []
    imdb.trivia.each do |trivium|
      movie.trivia.create(text: trivium)
    end
  end
  handle_asynchronously :fetch_trivia, queue: 'trivia'
end
