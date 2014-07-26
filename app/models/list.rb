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
#
# Indexes
#
#  index_lists_on_name                   (name)
#  index_lists_on_user_id_and_list_type  (user_id,list_type)
#  index_lists_on_user_id_and_name       (user_id,name)
#

class List < ActiveRecord::Base
  enum list_type: [:movie, :person]
  
  belongs_to :user
  has_many :list_entries, dependent: :destroy
  has_many :movies, through: :list_entries, source: :listable, source_type: 'Movie'
  has_many :people, through: :list_entries, source: :listable, source_type: 'Person'
  
  validates :name, uniqueness: { scope: :user,
                                 case_sensitive: false, 
                                 message: 'You already have a list with this name' }
  
  def toggle_entry(user, object)
    return false unless user == self.user
    return false unless list_type == object.class.to_s.downcase
    in_list = list_entries.exists? listable: object
    in_list ? remove(object) : add(object)
    reload
  end
  
  private
  
    def add(object)
      list_entries.create(listable: object)
    end
    
    def remove(object)
      list_entries.find_by(listable: object).destroy
    end
end
