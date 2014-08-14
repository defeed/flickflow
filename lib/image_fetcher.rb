class ImageFetcher < Struct.new(:image_id)
  def perform
    image = Image.find_by(id: image_id)
    return nil if image.nil? || image.file.present?
    
    if image.remote_url
      source_file = MiniMagick::Image.open image.remote_url
      image.file = source_file
      image.save
    end
  end
end
