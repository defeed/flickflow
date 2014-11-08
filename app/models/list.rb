# == Schema Information
#
# Table name: lists
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  list_type  :integer
#  name       :string(255)
#  is_private :boolean          default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#  slug       :string(255)
#
# Indexes
#
#  index_lists_on_name                   (name)
#  index_lists_on_slug                   (slug)
#  index_lists_on_user_id_and_list_type  (user_id,list_type)
#  index_lists_on_user_id_and_name       (user_id,name)
#

class List < ActiveRecord::Base
  include FriendlyId
  
  enum list_type: [:movie, :person]
  
  belongs_to :user
  friendly_id :name, use: :scoped, scope: :user
  
  has_many :list_entries, dependent: :destroy
  has_many :movies, through: :list_entries, source: :listable, source_type: 'Movie'
  has_many :people, through: :list_entries, source: :listable, source_type: 'Person'
  
  validates :name, uniqueness: { scope: :user,
                                 case_sensitive: false, 
                                 message: 'You already have a list with this name' }
  
  def toggle object
    return false unless list_type == object.class.to_s.downcase
    includes?(object) ? remove(object) : add(object)
  end
  
  def add object
    list_entries.create(listable: object)
    touch
    reload
  end
  
  def remove object
    list_entries.find_by(listable: object).destroy
    touch
    reload
  end
  
  def includes? object
    list_entries.exists? listable: object
  end
  
  def should_generate_new_friendly_id?
    name_changed? || super
  end
end
