json.extract! @movie, :id, :imdb_id, :title, :original_title, :year, :runtime, :mpaa_rating, :description, :storyline

json.is_released @movie.released?
json.release_date @movie.released_on

json.poster do |json|
  json.partial! 'api/posters/poster', poster: @movie.primary_poster
end

json.directed_by @directors, :id, :imdb_id, :name
json.starred_actors @starred_actors, :id, :imdb_id, :name
json.genres @movie.genres, :id, :name
json.languages @movie.languages, :id, :code, :name
json.countries @movie.countries, :id, :code, :name

json.ratings do
  json.imdb do |json|
    json.average @movie.imdb_rating
    json.count @movie.imdb_rating_count
  end
  
  json.rotten_tomatoes do |json|
    if @movie.rotten_critics_rating > 0
      json.critics_average @movie.rotten_critics_rating
      json.audience_average @movie.rotten_audience_rating
      json.waiting_score nil
    else
      json.critics_average nil
      json.audience_average nil
      json.waiting_score @movie.rotten_audience_rating
    end
  end
  
  json.metacritic @movie.metacritic_rating
end

json.extract! @movie, :created_at, :updated_at
