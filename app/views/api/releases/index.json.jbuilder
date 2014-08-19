json.array! @releases do |release|
  json.extract! release, :id
  json.country do
    json.extract! release.country, :id, :code, :name
  end
  json.extract! release, :released_on, :comment
end
