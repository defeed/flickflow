$ ->
  $('.thumbnail-poster').tooltip()
  
  $('#list-toggler').on 'click', '.btn', (event) ->
    event.preventDefault()
    list_toggler = $(this).parent()
    list_button = $(this)
    movie_id = list_toggler.data('movie-id')
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
          else
            list_item.removeClass('btn-on')
  
  
  $('.credits-expander').on 'click', (event) ->
    event.preventDefault()
    $('.credits-row').toggleClass('expanded')
    $(this).find('i').toggleClass('fa-chevron-circle-down').toggleClass('fa-chevron-circle-up')
