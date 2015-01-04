MovieFetchJob = Struct.new(:imdb_id) do
  def perform
    MovieFetcher.new(imdb_id).fetch
  end

  def queue_name
    'movies'
  end
end

class PeopleFetchJob < MovieFetchJob
  def perform
    MovieFetcher.new(imdb_id).fetch_people
  end

  def queue_name
    'people'
  end
end

class ReleasesFetchJob < MovieFetchJob
  def perform
    MovieFetcher.new(imdb_id).fetch_release_info
  end

  def queue_name
    'releases'
  end
end

class BackdropsFetchJob < MovieFetchJob
  def perform
    MovieFetcher.new(imdb_id).fetch_backdrops
  end

  def queue
    'backdrops'
  end
end

class VideosFetchJob < MovieFetchJob
  def perform
    MovieFetcher.new(imdb_id).fetch_videos
  end

  def queue
    'videos'
  end
end

class KeywordsFetchJob < MovieFetchJob
  def perform
    MovieFetcher.new(imdb_id).fetch_keywords
  end

  def queue_name
    'keywords'
  end
end

class RecommendationsFetchJob < MovieFetchJob
  def perform
    MovieFetcher.new(imdb_id).fetch_recommended_movies
  end

  def queue_name
    'recommendations'
  end
end

class CriticReviewsFetchJob < MovieFetchJob
  def perform
    MovieFetcher.new(imdb_id).fetch_critic_reviews
  end

  def queue_name
    'reviews'
  end
end

class TriviaFetchJob < MovieFetchJob
  def perform
    MovieFetcher.new(imdb_id).fetch_trivia
  end

  def queue_name
    'trivia'
  end
end
