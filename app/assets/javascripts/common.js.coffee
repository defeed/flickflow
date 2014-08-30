$ ->
  $('#show_password').on 'click', ->
    if $('#show_password').prop('checked')
      $('#user_password').prop('type', 'text')
    else
      $('#user_password').prop('type', 'password')
