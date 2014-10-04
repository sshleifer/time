Backbone.$ = $

x = (y) ->
  alert y
  return 12

k = ->
  alert 10

other = (tmp) ->
  lol()
  return tmp


# Can't start doing stuff until everything is there
$(document).ready ->


  $('#mydiv').html('<p>this is a paragraph</p>')

  # Needs to be passed a function
  #$('#js-button').click k
  #$('#js-button').click -> x 12

myview = Backbone.View.extend
  initialize: ->
    alert 'init'
  events:
    "click #js-button": "render"
  render: ->
    alert 'please work'
view = new myview(el: $('#bb'))
