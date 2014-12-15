namespace :flickflow do
  desc 'Parse 10,000 Most Popular Feature Films and set popularity index'
  task :update_pop_index do
    start = 1
    offset = 250
    index = 1

    while start <= 10_000
      options = {
        start: start
      }

      list = Spotlite::Movie.search(options)

      list.each do |movie|
        m = Movie.find_or_create_by(imdb_id: movie.imdb_id)
        m.update(title: movie.title, year: movie.year, pop_index: index)
        index += 1
        puts [index, movie.imdb_id, movie.title, movie.year].join(' - ')
      end

      start += offset
    end
  end

  desc 'Parse 50,000 Most Popular Feature Films and set popularity index'
  task :update_pop_index_full do
    start = 1
    offset = 250
    index = 1

    while start <= 50_000
      options = {
        start: start
      }

      list = Spotlite::Movie.search(options)

      list.each do |movie|
        m = Movie.find_or_create_by(imdb_id: movie.imdb_id)
        m.update(title: movie.title, year: movie.year, pop_index: index)
        index += 1
        puts [index, movie.imdb_id, movie.title, movie.year].join(' - ')
      end

      start += offset
    end
  end

  desc 'Fetch 1000 Most Popular by Pop Index'
  task :fetch_pop_index_1000 do
    movies = Movie.order(:pop_index).limit(1000)
    movies.each(&:fetch)
  end

  desc 'Fetch 1000 Most Popular by Pop Index Recommendations'
  task :fetch_pop_index_1000_recommendations do
    movies = Movie.order(:pop_index).limit(1000)
    movies.each{ |movie| movie.fetch_recommended_movies(true) }
  end

  desc 'Fetch Most Popular Feature Films With Production Status: Released and At Least 3,000 Votes'
  task :released_with_3000_votes do
    start = 1
    offset = 250

    while start <= 11_000
      options = {
        start: start,
        production_status: 'released',
        num_votes: '3000,'
      }

      list = Spotlite::Movie.search(options)

      list.each do |movie|
        Movie.fetch(movie.imdb_id)
        puts [movie.imdb_id, movie.title, movie.year].join(' - ')
      end

      start += offset
    end
  end
end
