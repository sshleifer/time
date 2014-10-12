url = require 'url'

myview = Backbone.View.extend
  el: '#body-js'
  initialize: ->
    @init_datetime()
  events:
    "keyup": "disable_submit"
    "click .messages": "clear_message"
    "click #undo-js": "undo_submit"

  disable_submit: ->
    start = $("#js-start").val()
    end = $("#js-end").val()
    act = $("input[name='activity']").val()
    if start and end and act and end >= start
      $("#submit-js").removeAttr("disabled")
    else
      $("#submit-js").attr("disabled", "disabled")

  clear_message: ->
    #$(".messages").fadeOut("Slow") # Interferes with undo_submit...

  undo_submit: ->
    user_id = url.parse(window.location.href).pathname.split('/')[2]
    $.ajax
      type: "POST"
      url: "/user/undo/#{user_id}"
      data: {check: "me out now!"}
      success: (data, text_status, jqxhr) ->
        $(".suc").html("<p>#{jqxhr.responseText[1..-2]}</p>")
      error: (jqxhr, type, text_status) ->
        $(".suc").html("<p>#{jqxhr.responseText[1..-2]}</p>")

  init_datetime: ->
    pad_string = (string, len) ->
      Array(len - String(string).length+1).join('0') + string
    d = new Date(Date.now())
    display = "#{d.getFullYear()}-#{pad_string(d.getMonth(),2)}-#{pad_string(d.getDate(),2)}T#{pad_string(d.getHours(), 2)}:#{pad_string(d.getMinutes(),2)}"
    $("#js-start").val(display)
    $("#js-end").val(display)

view = new myview()
