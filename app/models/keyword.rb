# == Schema Information
#
# Table name: keywords
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Keyword < ActiveRecord::Base
  has_and_belongs_to_many :movies
end
