class Participation < ActiveRecord::Base
  belongs_to :movie
  belongs_to :person
  
  enum job: [:actor, :star, :director, :writer, :producer]
  
  validates_uniqueness_of :credit, scope: [:movie_id, :person_id, :job]
    
  def imdb_id
    person.imdb_id
  end
  
  def name
    person.name
  end
end
