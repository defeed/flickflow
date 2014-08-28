# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('#show_password').on 'click', ->
    if $('#show_password').prop('checked')
      $('#user_password').prop('type', 'text')
    else
      $('#user_password').prop('type', 'password')
