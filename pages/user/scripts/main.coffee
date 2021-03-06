url = require 'url'


add_time = Backbone.View.extend
  el: '#js-time'
  initialize: ->
    @init_datetime()
    @autocomplete_activity()
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
      $("#js-submit_time").removeAttr("disabled")
    else
      $("#js-submit_time").attr("disabled", "disabled")


  undo_submit: ->
    user_id = url.parse(window.location.href).pathname.split('/')[2]
    $.ajax
      type: "POST"
      url: "/user/undo_event/#{user_id}"
      success: (data, text_status, jqxhr) ->
        $(".suc").html("<p>#{jqxhr.responseText[1..-2]}</p>")
      error: (jqxhr, type, text_status) ->
        $(".suc").html("<p>#{jqxhr.responseText[1..-2]}</p>")

  init_datetime: ->
    pad_string = (string, len) ->
      Array(len - String(string).length+1).join('0') + string
    d = new Date(Date.now())
    display = "#{d.getFullYear()}-#{pad_string(d.getMonth() + 1,2)}-#{pad_string(d.getDate(),2)}T#{pad_string(d.getHours(), 2)}:#{pad_string(d.getMinutes(),2)}"
    $("#js-start").val(display)
    $("#js-end").val(display)

  autocomplete_activity: ->
    @lookup_activities (err, res) ->
      $("#js-add_activity").autocomplete {source: res}

  lookup_activities: (cb) ->
    user_id = url.parse(window.location.href).pathname.split('/')[2]
    $.ajax
      type: "POST"
      url: "/user/lookup_activities/#{user_id}"
      success: (data, text_status, jqxhr) ->
        cb null, data
      error: (jqxhr, type, text_status) ->
        cb text_status, null

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


todo_list = Backbone.View.extend
  el: "#js-todo_list"
  initialize: ->
    @display_todos()
  events:
    "mouseenter .done": "enter"
    "mouseleave .done": "leave"
    "click .done": "remove_todo"

  enter: (event) ->
    $(event.currentTarget).addClass("selected")
  leave: (event) ->
    $(event.currentTarget).removeClass("selected")

  remove_todo: (event) ->
    user_id = url.parse(window.location.href).pathname.split('/')[2]
    $.ajax
      type: "POST"
      url: "/user/remove_todo/#{user_id}"
      data: (id: $(event.currentTarget).attr("class"))
      success: (data, text_status, jqxhr) =>
        @display_todos()
      # Do something on error?
      #error: (jqxhr, type, text_status) ->
      # cb text_status, null



  display_todos: ->
    @lookup_todos (err, res) =>
      @autocomplete_todos(if res.activities? then res.activities else [])
      disp = if res.todos? then res.todos else []
      html = ""
      if disp.length is 0
        html = "<p>You must have things to do!</p>"
      else
        html = "<table><tr><th>Name</th><th>Estimated Time</th><th>Done</th></tr>"
        _.each disp, (item) ->
          html += "<tr><td>#{item.activity}</td><td>#{item.estimated_time}</td><td class='done #{item.id}'></td></tr>"
        html += "</table>"
      $("#js-items").html(html)


  autocomplete_todos: (res) ->
    $("#js-todo_activity").autocomplete {source: res}


  lookup_todos: (cb) ->
    user_id = url.parse(window.location.href).pathname.split('/')[2]
    $.ajax
      type: "POST"
      url: "/user/lookup_todo/#{user_id}"
      success: (data, text_status, jqxhr) ->
        cb null, data
      error: (jqxhr, type, text_status) ->
        cb text_status, null

delete_user = Backbone.View.extend
  el: "#js-delete"
  events:
    "click #js-delete_user": "open_modal"
    #"click #js-yes": "delete_user"
    "click #js-no": "close_modal"
  open_modal: ->
    $("#js-modal").addClass("modal-open")
  close_modal: ->
    $("#js-modal").removeClass("modal-open")
  delete_user: ->
    user_id = url.parse(window.location.href).pathname.split('/')[2]
    $.post "/user/delete_user/#{user_id}"

new add_todo()
new add_time()
new todo_list()
new delete_user()
