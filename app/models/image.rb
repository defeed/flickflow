# == Schema Information
#
# Table name: images
#
#  id             :integer          not null, primary key
#  type           :string(255)
#  file           :string(255)
#  imageable_id   :integer
#  imageable_type :string(255)
#  remote_url     :string(255)
#  is_primary     :boolean          default(FALSE)
#  created_at     :datetime
#  updated_at     :datetime
#
# Indexes
#
#  index_images_on_imageable_id_and_imageable_type  (imageable_id,imageable_type)
#

class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true
end
