module ApplicationHelper
  def title
    base_title = 'FlickFlow'
    @title.nil? ? base_title : "#{@title} &middot; #{base_title}".html_safe
  end
  
  def poster_image_for movie, version, options={}
    primary_poster = movie.primary_poster
    file_url = primary_poster.file_url(version) if primary_poster
    src = file_url.presence || "#{version}_no_poster.png"
    image_tag src, options
  end
  
  def trailer_button youtube_id
    unless youtube_id.empty?
      content_tag :a, id: 'watch-trailer', class: 'btn btn-default btn-lg btn-block sublime', data: { 'youtube-id' => youtube_id }, href: "##{youtube_id}" do
        fa_icon 'play-circle-o', text: 'Play Trailer'
      end
    end
  end
  
  def sublime_video youtube_id, width = 1280, height = 720
    unless youtube_id.empty?
      content_tag :video, id: youtube_id, width: width, height: height, style: "display:none", data: { uid: youtube_id, 'youtube_id' => youtube_id }, preload: 'none' do
        nil
      end
    end
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
