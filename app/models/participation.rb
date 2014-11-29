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

# == Schema Information
#
# Table name: participations
#
#  id         :integer          not null, primary key
#  movie_id   :integer
#  person_id  :integer
#  job        :integer
#  credit     :string(255)
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_participations_on_movie_id_and_person_id  (movie_id,person_id)
#  participations_index                            (movie_id,person_id,job,credit) UNIQUE
#
