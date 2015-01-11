class ImageFetcher
  def initialize(imdb_id, image_url)
    @image_url = image_url
    @movie = Movie.find_or_create_by(imdb_id: imdb_id)
  end

  def fetch_poster
    @movie.posters.update_all(is_primary: false)
    poster = Poster.create(imageable: @movie, remote_url: @image_url, is_primary: true)
    process_image(poster)
  end

  def fetch_backdrop
    @movie.backdrops.update_all(is_primary: false)
    backdrop = Backdrop.create(imageable: @movie, remote_url: @image_url, is_primary: true)
    process_image(backdrop)
  end

  def process_image(image)
    source_file = MiniMagick::Image.open image.remote_url
    image.file = source_file
    image.save
  end
end
