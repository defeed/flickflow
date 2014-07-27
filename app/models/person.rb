# == Schema Information
#
# Table name: people
#
#  id         :integer          not null, primary key
#  imdb_id    :string(255)
#  name       :string(255)
#  birth_name :string(255)
#  born_on    :date
#  died_on    :date
#  bio        :text
#  photo_url  :string(255)
#  created_at :datetime
#  updated_at :datetime
#  slug       :string(255)
#
# Indexes
#
#  index_people_on_imdb_id  (imdb_id) UNIQUE
#  index_people_on_name     (name)
#  index_people_on_slug     (slug) UNIQUE
#

class Person < ActiveRecord::Base
  include FriendlyId
  friendly_id :slug_candicates
  
  has_many :actorships,    -> { where job: Participation.jobs[:actor] },    class_name: 'Participation'
  has_many :starships,     -> { where job: Participation.jobs[:star] },     class_name: 'Participation'
  has_many :directorships, -> { where job: Participation.jobs[:director] }, class_name: 'Participation'
  has_many :writerships,   -> { where job: Participation.jobs[:writer] },   class_name: 'Participation'
  has_many :producerships, -> { where job: Participation.jobs[:producer] }, class_name: 'Participation'

  
  has_many :participations, dependent: :destroy
  has_many :movies, through: :participations
  
  has_many :list_entries, as: :listable, dependent: :destroy
  has_many :lists, through: :list_entries
  
  def toggle_in_list(user, list)
    list.toggle_entry user, self
  end
  
  def slug_candicates
    [
      :name,
      [:imdb_id, :name]
    ]
  end
  
  def should_generate_new_friendly_id?
    name_changed? || super
  end
end
