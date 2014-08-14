module ApplicationHelper
  def poster_image_for movie, version, options={}
    primary_poster = movie.primary_poster
    file_url = primary_poster.file_url(version) if primary_poster
    src = file_url.presence || "#{version}_no_poster.png"
    image_tag asset_path(src), options
  end
  
  def format_runtime minutes
    hours = minutes / 60
    minutes = '%02d' % (minutes % 60)
    "#{hours}:#{minutes}"
  end
end
