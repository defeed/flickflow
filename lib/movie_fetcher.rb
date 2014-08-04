class MovieFetcher < Struct.new(:imdb_id, :page, :force)
  def perform
    return nil unless fetch_required_for? page, force
    
    case page
    when :all
      fetch_all
    when :basic_info
      fetch_basic_info
    when :people
      fetch_people
    when :release_info
      fetch_release_info
    when :keywords
      fetch_keywords
    when :trivia
      fetch_trivia
    when :recommended_movies
      fetch_recommended_movies
    when :critic_reviews
      fetch_critic_reviews
    else nil
    end
  end
  
  def fetch_all
    fetch_basic_info
    fetch_people
    fetch_release_info
    fetch_keywords
    fetch_trivia
    fetch_critic_reviews
  end
  
  def fetch_basic_info
    imdb = Spotlite::Movie.new(imdb_id)
    movie = Movie.find_by(imdb_id: imdb.imdb_id)
    rotten = RottenMovie.find(imdb: imdb.imdb_id)
        
    movie.imdb_id                = imdb.imdb_id
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
    
    log_fetch(Fetch.pages[:basic_info], imdb.response)
    movie.save
  end
  
  def fetch_people
    imdb = Spotlite::Movie.new(imdb_id)
    movie = Movie.find_by(imdb_id: imdb.imdb_id)

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
    
    log_fetch(Fetch.pages[:people], imdb.response)
    movie.save
  end
  handle_asynchronously :fetch_people, queue: 'people'
    
  def fetch_keywords
    imdb = Spotlite::Movie.new(imdb_id)
    movie = Movie.find_by(imdb_id: imdb.imdb_id)
    
    movie.keywords = []
    imdb.keywords.each do |keyword|
      movie.keywords << Keyword.find_or_create_by(name: keyword)
    end
    
    log_fetch(Fetch.pages[:keywords], imdb.response)
    movie.save
  end
  handle_asynchronously :fetch_keywords, queue: 'keywords'
  
  def fetch_release_info
    imdb = Spotlite::Movie.new(imdb_id)
    movie = Movie.find_by(imdb_id: imdb.imdb_id)
    
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
    
    log_fetch(Fetch.pages[:release_info], imdb.response)
    movie.save
  end
  handle_asynchronously :fetch_release_info, queue: 'release_info'
  
  def fetch_trivia
    imdb = Spotlite::Movie.new(imdb_id)
    movie = Movie.find_by(imdb_id: imdb.imdb_id)
    
    movie.trivia = []
    imdb.trivia.each do |trivium|
      movie.trivia.create(text: trivium)
    end
    
    log_fetch(Fetch.pages[:trivia], imdb.response)
  end
  handle_asynchronously :fetch_trivia, queue: 'trivia'
  
  def fetch_critic_reviews
    imdb = Spotlite::Movie.new(imdb_id)
    movie = Movie.find_by(imdb_id: imdb.imdb_id)
    
    movie.critic_reviews = []
    imdb.critic_reviews.each do |review|
      movie.critic_reviews.create(author: review[:author], publisher: review[:source], excerpt: review[:excerpt], rating: review[:score])
    end
    
    log_fetch(Fetch.pages[:critic_reviews], imdb.response)
  end
  handle_asynchronously :fetch_critic_reviews, queue: 'critic_reviews'
  
  def fetch_recommended_movies
    imdb = Spotlite::Movie.new(imdb_id)
    movie = Movie.find_by(imdb_id: imdb.imdb_id)
        
    movie.recommendations = []
    imdb.recommended_movies.each do |recommended_movie|
      other_movie = Movie.find_or_create_by(imdb_id: recommended_movie.imdb_id)
      movie.recommendations.build(other_movie_id: other_movie.id)
    end
    
    movie.save
    
    movie.recommended_movies.unfetched.each do |recommended_movie|
      Delayed::Job.enqueue MovieFetcher.new(recommended_movie.imdb_id, :all)
    end
    
    log_fetch(Fetch.pages[:recommended_movies], imdb.response)
  end
  handle_asynchronously :fetch_recommended_movies, queue: 'recommended_movies'
  
  private
  
    def log_fetch page, response
      movie = Movie.find_by(imdb_id: imdb_id)
      movie.fetches.create page: page, response_code: response[:code], response_message: response[:message]
    end
    
    def fetch_required_for? page, force = false
      last_fetch = last_fetch_for page
      return true if force || last_fetch.nil?
      Time.now.utc - last_fetch.created_at > fetch_delay
    end
    
    def last_fetch_for page
      movie = Movie.find_by(imdb_id: imdb_id)
      page == :all ? movie.fetches.last : movie.fetches.where(page: Fetch.pages[page]).last
    end
    
    def fetch_delay
      movie = Movie.find_by(imdb_id: imdb_id)
      
      if movie.released_on.present?
        days_difference = (Date.today - movie.released_on).abs.to_i
        
        # The more distant release date from today is (in past or future), the more delay between refetching
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
      else
        1.week
      end
    end
end
