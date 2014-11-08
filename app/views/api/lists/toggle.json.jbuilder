json.array! @lists do |list|
  json.id list.slug
  json.presence list.includes?(@object)
  json.count list.movies.count
end
