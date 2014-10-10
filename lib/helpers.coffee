_ = require 'underscore'

module.exports =
  
  # Should we maybe throw an error rather than returning false?
  generate_userid: (id) =>
    if id?
      return false if ' ' in id or id.length < 10 or id.length > 255
      id
    else
      shorturl = Math.random().toString(36)[2..11]
      return shorturl if shorturl.length is 10
      @generate_userid()

  correct_timezone: (event) ->
    _.each ['start_time', 'end_time'], (i) ->
      event[i] = new Date(Date.parse event[i])
      event[i].setTime(event[i].getTime() + event[i].getTimezoneOffset()*60*1000)
    event

