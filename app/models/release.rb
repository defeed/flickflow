class Release < ActiveRecord::Base
  belongs_to :country
  belongs_to :movie
end
