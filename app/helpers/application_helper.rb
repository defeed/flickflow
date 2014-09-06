module ApplicationHelper
  def title
    base_title = 'FlickFlow'
    @title.nil? ? base_title : "#{@title} &middot; #{base_title}".html_safe
  end
  
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
  
  BOOTSTRAP_FLASH_MSGS = {
    success: 'alert-success',
    error: 'alert-danger',
    alert: 'alert-warning',
    notice: 'alert-info'
  }

  def bootstrap_class_for flash_type
    BOOTSTRAP_FLASH_MSGS.fetch(flash_type.to_sym, flash_type.to_s)
  end
end
