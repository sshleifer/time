
myview = Backbone.View.extend
  el: '#form-js'
  events:
    "keyup": "disable_submit"
  initialize: ->
    @render()
  render: ->
    #@.$el.html("hello?")

  disable_submit: ->
    name = $("input[name='name']").val()
    email = $("input[name='email']").val()
    if name and email
      $("#button-js").removeAttr("disabled")
    else
      $("#button-js").attr("disabled", "disabled")
    
view = new myview()
