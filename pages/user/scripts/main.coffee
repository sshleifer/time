init_datetime = ->
  pad_string = (string, len) ->
    Array(len - String(string).length+1).join('0') + string
  d = new Date(Date.now())
  display = "#{d.getFullYear()}-#{pad_string(d.getMonth(),2)}-#{pad_string(d.getDate(),2)}T#{pad_string(d.getHours(), 2)}:#{pad_string(d.getMinutes(),2)}"
  $("#js-start").val(display)
  $("#js-end").val(display)


myview = Backbone.View.extend
  el: '#body-js'
  initialize: ->
    init_datetime()
  events:
    "keyup": "disable_submit"
    "click .messages": "clear_message"

  disable_submit: ->
    start = $("#js-start").val()
    end = $("#js-end").val()
    act = $("input[name='activity']").val()
    if start and end and act and end > start
      $("#button-js").removeAttr("disabled")
    else
      $("#button-js").attr("disabled", "disabled")

  clear_message: ->
    $(".messages").fadeOut("Slow")

view = new myview()
