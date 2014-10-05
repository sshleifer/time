Backbone.$ = $

x = (y) ->
  alert y
  return 12

k = ->
  alert 10

other = (tmp) ->
  lol()
  return tmp


myview = Backbone.View.extend
  initialize: ->
    alert 'init'
  events:
    "click #js-button": "render"
  render: ->
    alert 'please work'
view = new myview(el: $('#bb'))
