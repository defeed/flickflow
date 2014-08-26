json.extract! @list, :id, :name, :list_type, :is_private, :user_id, :created_at, :updated_at
json.movies do
  json.array! @list.movies, partial: 'api/movies/movie', as: :movie
end
