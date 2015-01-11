class AuthToken < ActiveRecord::Base
  belongs_to :user

  def self.generate
    loop do
      token = SecureRandom.hex(21)
      break token unless AuthToken.exists? token: token
    end
  end
end

# == Schema Information
#
# Table name: auth_tokens
#
#  id         :integer          not null, primary key
#  token      :string           not null
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_auth_tokens_on_token  (token) UNIQUE
#
