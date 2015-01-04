ImageFetchJob = Struct.new(:imdb_id, :image_type, :image_url) do
  def perform
    return if image_url.nil?
    return unless need_to_fetch?(image_url)
    ImageFetcher.new(imdb_id, image_url).send("fetch_#{image_type}")
  end

  def queue
    'images'
  end

  private

  def need_to_fetch?(image_url)
    image = Image.find_by(remote_url: image_url)
    image.nil? || image.file.nil?
  end
end
