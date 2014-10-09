_ = require 'underscore'

module.exports =
  
  generate_userid: =>
    shorturl = Math.random().toString(36)[2..11]
    return shorturl if shorturl.length is 10
    @generate_userid()

  correct_timezone: (event) ->
    _.each ['start_time', 'end_time'], (i) ->
      event[i] = new Date(Date.parse event[i])
      event[i].setTime(event[i].getTime() + event[i].getTimezoneOffset()*60*1000)
    event

