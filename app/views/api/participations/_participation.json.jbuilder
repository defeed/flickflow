if key == :movie
  json.person do
    json.partial! 'api/people/person', person: participation.person
  end
elsif key == :person
  json.movie do
    json.partial! 'api/movies/movie', movie: participation.movie
  end
end
json.credit participation.credit.blank? ? nil : participation.credit
