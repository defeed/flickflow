class Fetch < ActiveRecord::Base
  enum page: [
    :general_info,
    :people,
    :release_info,
    :keywords,
    :trivia,
    :critic_reviews,
    :recommended_movies,
    :videos,
    :backdrops
  ]

  belongs_to :fetchable, polymorphic: true

  scope :with_response_code, -> (code) { where 'response_code = ?', code }
  scope :failed, -> { where 'response_code >= ?', 400 }
  scope :not_found, -> { with_response_code(404) }

  def success?
    response_code == 200
  end
end

# == Schema Information
#
# Table name: fetches
#
#  id             :integer          not null, primary key
#  fetchable_id   :integer
#  fetchable_type :string
#  page           :integer
#  created_at     :datetime
#  updated_at     :datetime
#
# Indexes
#
#  index_fetches_on_fetchable_id_and_fetchable_type  (fetchable_id,fetchable_type)
#
