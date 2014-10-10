getQueryParameters = () ->
  document.location.search.replace(/(^\?)/, "").split("&").map(((n) ->
    n = n.split("=")
    this[n[0]] = n[1]
    this).bind({}))[0]

pad_string = (string, len) ->
  Array(len - String(string).length+1).join('0') + string

$(document).ready ->
  
  # set defaults for start and end
  d = new Date(Date.now())
  display = "#{d.getFullYear()}-#{pad_string(d.getMonth(),2)}-#{pad_string(d.getDate(),2)}T#{pad_string(d.getHours(), 2)}:#{pad_string(d.getMinutes(),2)}"
  $("#js-start").val(display)
  $("#js-end").val(display)

  
