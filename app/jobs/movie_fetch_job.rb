MovieFetchJob = Struct.new(:imdb_id, :page) do
  def perform
    MovieFetcher.new(imdb_id).send("fetch_#{page}")
  end

  def success(job)
    log_fetch(page)
    puts "Fetched: #{imdb_id} - #{page}"
  end

  def queue
    "#{page}"
  end

  private

  def log_fetch(page)
    movie = Movie.find_by(imdb_id: imdb_id)
    movie.fetches.create(page: Fetch.pages[page])
  end
end
