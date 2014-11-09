url = require 'url'

add_todo = Backbone.View.extend
  el: "#js-todo"
  events:
    "keyup": "disable_submit"
    "click": "disable_submit"

  # todos
  disable_submit: ->
    est = $("#js-estimate").val()
    act = $("#js-todo_activity").val()
    if est and est > 0 and act
      $("#js-submit_todo").removeAttr("disabled")
    else
      $("#js-submit_todo").attr("disabled", "disabled")

add_time = Backbone.View.extend
  el: '#js-time'
  initialize: ->
    @init_datetime()
  events:
    "click .messages": "clear_message"
    "click #js-undo": "undo_submit"
    "keyup": "disable_submit"

  clear_message: ->
    #$(".messages").fadeOut("Slow") # Interferes with undo_submit...

  # events
  disable_submit: ->
    start = $("#js-start").val()
    end = $("#js-end").val()
    act = $("#js-add_activity").val() # check works
    if start and end and act and end >= start
      $("#js-submit").removeAttr("disabled")
    else
      $("#js-submit").attr("disabled", "disabled")


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

new add_todo()
new add_time()
