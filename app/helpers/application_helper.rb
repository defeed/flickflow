module ApplicationHelper
  def title
    base_title = 'FlickFlow'
    @title.nil? ? base_title : "#{@title} &middot; #{base_title}".html_safe
  end

  def poster_image_for(movie, version, options = {})
    primary_poster = movie.primary_poster
    file_url = primary_poster.file_url(version) if primary_poster
    src = file_url.presence || "#{version}_no_poster.png"
    image_tag src, options
  end

  def backdrop_for(movie)
    if movie.backdrops.present? && backdrop_url = movie.primary_backdrop.file_url
      content_tag :div, id: 'backdrop', style: "background-image: url('#{backdrop_url}')" do
        if @trailer
          content_tag :div, id: 'trailer-container' do
            trailer_button @trailer.youtube_id
          end
        end
      end
    end
  end

  def rating_image(type, score, title = '', size = '50x50')
    case type
    when 'imdb'
      filename = 'imdb.png'
      image_tag('imdb.png', size: size, title: title)
    when 'rt_critics'
      filename = score >= 60 ? 'fresh-tomato.png' : 'rotten-tomato.png'
    when 'rt_audience'
      filename = score >= 60 ? 'popcorn.png' : 'spilled-popcorn.png'
    when 'metacritic'
      filename = 'metacritic.png'
    end

    image_tag(filename, size: size, title: title)
  end

  def imdb_rating_count(count)
    "#{number_to_human(count, units: {thousand: 'k', million: 'm'}, format: '%n%u')} users"
  end

  def trailer_button(youtube_id)
    content_tag :a, id: 'play-trailer', class: 'sublime', data: { 'youtube-id' => youtube_id }, href: "##{youtube_id}" do
      fa_icon 'play-circle-o'
    end
  end

  def sublime_video(youtube_id, width = 1280, height = 720)
    content_tag :video, id: youtube_id, width: width, height: height, style: 'display:none', data: { uid: youtube_id, 'youtube_id' => youtube_id }, preload: 'none' do
      nil
    end
  end

  def format_runtime(minutes)
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

  def bootstrap_class_for(flash_type)
    BOOTSTRAP_FLASH_MSGS.fetch(flash_type.to_sym, flash_type.to_s)
  end
end
