json.extract! movie, :id, :title, :year
json.poster do |json|
  json.partial! 'api/posters/poster', poster: movie.primary_poster
end
json.extract! movie, :created_at, :updated_at
