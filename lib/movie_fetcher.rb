class MovieFetcher < Struct.new(:imdb_id, :page, :force)
  def perform
    page  = self.page || :all
    force = self.force || false
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
    when :stills
      fetch_stills
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
    # fetch_stills
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
    
    if imdb.poster_url && !Poster.exists?(remote_url: imdb.poster_url)
      movie.posters.update_all(is_primary: false)
      poster = Poster.create(imageable: movie, remote_url: imdb.poster_url, is_primary: true)
      Delayed::Job.enqueue ImageFetcher.new(poster.id)
    end
    
    has_data = [movie.title, movie.original_title, movie.year, movie.imdb_rating, movie.imdb_rating_count, movie.runtime, movie.description, movie.storyline, movie.mpaa_rating].any? &:present?
    log_fetch :basic_info, imdb.response, has_data
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
    
    movie.save
    movie.reload
    has_data = movie.participations.present?
    log_fetch :people, imdb.response, has_data
  end
  handle_asynchronously :fetch_people, queue: 'people'
    
  def fetch_keywords
    imdb = Spotlite::Movie.new(imdb_id)
    movie = Movie.find_by(imdb_id: imdb.imdb_id)
    
    movie.keywords = []
    imdb.keywords.each do |keyword|
      movie.keywords << Keyword.find_or_create_by(name: keyword)
    end
    
    movie.save
    has_data = movie.keywords.present?
    log_fetch :keywords, imdb.response, has_data
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
    
    movie.save
    has_data = [movie.releases, movie.alternative_titles].any? &:present?
    log_fetch :release_info, imdb.response, has_data
  end
  handle_asynchronously :fetch_release_info, queue: 'release_info'
  
  def fetch_trivia
    imdb = Spotlite::Movie.new(imdb_id)
    movie = Movie.find_by(imdb_id: imdb.imdb_id)
    
    movie.trivia = []
    imdb.trivia.each do |trivium|
      movie.trivia.create(text: trivium)
    end
    
    has_data = movie.trivia.present?
    log_fetch :trivia, imdb.response, has_data
  end
  handle_asynchronously :fetch_trivia, queue: 'trivia'
  
  def fetch_critic_reviews
    imdb = Spotlite::Movie.new(imdb_id)
    movie = Movie.find_by(imdb_id: imdb.imdb_id)
    
    movie.critic_reviews = []
    imdb.critic_reviews.each do |review|
      movie.critic_reviews.create(author: review[:author], publisher: review[:source], excerpt: review[:excerpt], rating: review[:score])
    end
    
    has_data = movie.critic_reviews.present?
    log_fetch :critic_reviews, imdb.response, has_data
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
    has_data = movie.recommendations.present?
    log_fetch :recommended_movies, imdb.response, has_data
    
    movie.recommended_movies.without_title.each do |recommended_movie|
      Delayed::Job.enqueue MovieFetcher.new(recommended_movie.imdb_id, :all)
    end
  end
  handle_asynchronously :fetch_recommended_movies, queue: 'recommended_movies'
  
  def fetch_stills
    imdb = Spotlite::Movie.new(imdb_id)
    movie = Movie.find_by(imdb_id: imdb.imdb_id)
    
    imdb.images.each do |image|
      return if Still.exists?(remote_url: image)
      
      still = Still.create(imageable: movie, remote_url: image)
      Delayed::Job.enqueue ImageFetcher.new(still.id)
    end
    
    has_data = imdb.images.any?
    log_fetch :stills, imdb.response, has_data
  end
  handle_asynchronously :fetch_stills, queue: 'stills'
  
  private
  
    def log_fetch page, response, has_data
      movie = Movie.find_by(imdb_id: imdb_id)
      movie.fetches.create page: Fetch.pages[page], response_code: response[:code], response_message: response[:message], has_data: has_data
    end
    
    def fetch_required_for? page, force
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
