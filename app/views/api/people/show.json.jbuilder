json.partial! 'api/people/person', person: @person
json.extract! @person, :birth_name, :born_on, :died_on, :bio, :created_at, :updated_at
