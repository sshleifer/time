myview = Backbone.View.extend
  el: '#body-js'
  initialize: ->
    @render()
  render: ->
    @.$el.html("hello?")
    
view = new myview()
