# == Schema Information
#
# Table name: users
#
#  id                              :integer          not null, primary key
#  name                            :string(255)
#  username                        :string(255)      not null
#  email                           :string(255)      not null
#  crypted_password                :string(255)      not null
#  salt                            :string(255)      not null
#  created_at                      :datetime
#  updated_at                      :datetime
#  remember_me_token               :string(255)
#  remember_me_token_expires_at    :datetime
#  reset_password_token            :string(255)
#  reset_password_token_expires_at :datetime
#  reset_password_email_sent_at    :datetime
#  last_login_at                   :datetime
#  last_logout_at                  :datetime
#  last_activity_at                :datetime
#  last_login_from_ip_address      :string(255)
#  slug                            :string(255)
#
# Indexes
#
#  index_users_on_email                                (email) UNIQUE
#  index_users_on_last_logout_at_and_last_activity_at  (last_logout_at,last_activity_at)
#  index_users_on_remember_me_token                    (remember_me_token)
#  index_users_on_reset_password_token                 (reset_password_token)
#  index_users_on_slug                                 (slug) UNIQUE
#  index_users_on_username                             (username) UNIQUE
#

class User < ActiveRecord::Base
  include FriendlyId
  friendly_id :username
  
  authenticates_with_sorcery!
  
  has_many :lists, dependent: :destroy
  
  after_create :create_default_user_lists, unless: Proc.new { |u| u.is_system_user? }
  
  def self.system
    User.find_by(username: 'flickflow')
  end
  
  def create_default_user_lists
    lists.movie.create name: 'Watchlist'
    lists.movie.create name: 'Watched'
    lists.movie.create name: 'Favorites'
    lists.person.create name: 'Favorite People'
  end
  
  def is_system_user?
    self == User.system
  end
end
