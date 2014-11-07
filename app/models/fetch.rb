# == Schema Information
#
# Table name: fetches
#
#  id               :integer          not null, primary key
#  fetchable_id     :integer
#  fetchable_type   :string(255)
#  page             :integer
#  response_code    :integer
#  response_message :string(255)
#  has_data         :boolean          default(FALSE)
#  created_at       :datetime
#  updated_at       :datetime
#
# Indexes
#
#  index_fetches_on_fetchable_id_and_fetchable_type  (fetchable_id,fetchable_type)
#

class Fetch < ActiveRecord::Base
  enum page: [:basic_info, :people, :release_info, :keywords, :trivia, :critic_reviews, :recommended_movies, :bio, :filmography, :images, :videos]
  belongs_to :fetchable, polymorphic: true
  
  scope :with_response_code, -> (code) { where 'response_code = ?', code }
  scope :failed, -> { where 'response_code >= ?', 400 }
  scope :not_found, -> { with_response_code(404) }
  
  def success?
    response_code == 200
  end
end
