class Person < ActiveRecord::Base
  has_many :actorships,    -> { where job: Participation.jobs[:actor] },    class_name: 'Participation'
  has_many :starships,     -> { where job: Participation.jobs[:star] },     class_name: 'Participation'
  has_many :directorships, -> { where job: Participation.jobs[:director] }, class_name: 'Participation'
  has_many :writerships,   -> { where job: Participation.jobs[:writer] },   class_name: 'Participation'
  has_many :producerships, -> { where job: Participation.jobs[:producer] }, class_name: 'Participation'

  
  has_many :participations, dependent: :destroy
  has_many :movies, through: :participations
end
