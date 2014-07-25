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
  has_many :list_entries
  has_many :movies, through: :list_entries, source: :listable, source_type: 'Movie'
  has_many :people, through: :list_entries, source: :listable, source_type: 'Person'
end
