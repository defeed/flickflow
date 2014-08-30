# == Schema Information
#
# Table name: users
#
#  id                              :integer          not null, primary key
#  name                            :string(255)
#  username                        :string(255)
#  email                           :string(255)
#  crypted_password                :string(255)
#  salt                            :string(255)
#  slug                            :string(255)
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
#
# Indexes
#
#  index_users_on_email                                (email)
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
  
  validates :username, format: { with: /\A[a-z0-9]+\z/i, message: 'can only contain digits 0-9 and letters A-Z.' },
                       length: { in: 2..20, message: 'must be 2 to 20 characters' },
                       uniqueness: { case_sensitive: false, message: 'is already taken. Choose another.' },
                       allow_blank: true
  
  validates :email,    format: { with: /\A.+@.+\..+\z/i, message: 'is invalid' },
                       uniqueness: { case_sensitive: false, message: 'is already taken. Choose another.' },
                       allow_blank: true
  validates :password, length: { minimum: 5, message: 'must be minimum 5 characters' },
                       allow_blank: true
  
  has_many :lists, dependent: :destroy
  
  has_one :auth_token, dependent: :destroy
  
  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications
  
  before_create :set_auth_token
  before_create :ensure_username_unique
  before_save   :ensure_username_present
  after_create  :create_default_user_lists, unless: Proc.new { |u| u.is_system_user? }
  
  def self.system
    User.find_by(username: 'flickflow')
  end
  
  def self.generate_username
    prefix = 'user'
    loop do
      username = "#{prefix}#{SecureRandom.random_number(1_000_000)}"
      break username unless User.exists? username: username
    end
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
  
  def should_generate_new_friendly_id?
    username_changed? || super
  end
  
  private
  
  def ensure_username_unique
    return unless User.exists? username: self.username
    prefix = self.username
    suffix = 0
    loop do
      self.username = "#{prefix}#{suffix+1}"
      break unless User.exists? username: self.username
    end
  end
  
  def ensure_username_present
    self.username = User.generate_username if self.username.blank?
  end
  
  def set_auth_token
    return if auth_token.present?
    self.auth_token = AuthToken.create(token: AuthToken.generate)
  end
end
