class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true

  after_create :set_uuid

  private

  def set_uuid
    update(uuid: SecureRandom.uuid)
  end
end

# == Schema Information
#
# Table name: images
#
#  id             :integer          not null, primary key
#  type           :string
#  file           :string
#  imageable_id   :integer
#  imageable_type :string
#  remote_url     :string
#  is_primary     :boolean          default("false")
#  uuid           :uuid
#  created_at     :datetime
#  updated_at     :datetime
#
# Indexes
#
#  index_images_on_imageable_type_and_imageable_id  (imageable_type,imageable_id)
#  index_images_on_remote_url                       (remote_url)
#
