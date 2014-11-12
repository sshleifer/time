_ = require 'underscore'

module.exports =
  
  generate_userid: (id) =>
    if id isnt '' and not _.isNull(id) and not _.isUndefined(id)
      return null if ' ' in id or id.length < 10 or id.length > 255
      id
    else
      shorturl = Math.random().toString(36)[2..11]
      return shorturl if shorturl.length is 10
      @generate_userid()
