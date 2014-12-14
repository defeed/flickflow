$ ->
  $('.thumbnail-poster').tooltip()
  $('.ratings-list img').tooltip()

  $('.thumbnail-poster').hover(
    -> $(this).find('.caption').slideDown('fast')
    -> $(this).find('.caption').fadeToggle()
  )

  $('.list-toggler').on 'click', '.btn', (event) ->
    event.preventDefault()
    list_toggler = $(this).parent()
    list_button = $(this)
    movie_id = list_toggler.data('movie-id')
    poster = $('#thumbnail-poster-' + movie_id)
    list_id = list_button.data('list-id')
    url = '/api/lists/' + list_id + '/toggle'
    data = { movie_id: movie_id }
    $.ajax
      type: 'POST',
      url: url,
      dataType: 'json'
      headers: {
        'Authorization': 'Token token=' + gon.api_token
      },
      data: data,
      success: (data) ->
        $.each data, (_, item) ->
          list_item = list_toggler.find('#' + item.id)
          if item.presence == true
            list_item.addClass('btn-on')
            poster.addClass('poster-' + item.id)
          else
            list_item.removeClass('btn-on')
            poster.removeClass('poster-' + item.id)
