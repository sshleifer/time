_ = require 'underscore'

module.exports =

  generate_userid: (id) =>
    if _.isString(id) and id.length
      return null if ' ' in id or id.length < 10 or id.length > 255 or not /^[\x00-\x7F]*$/.test(id)
    else
      id = Math.random().toString(36)[2..11]
      return @generate_userid() if id.length isnt 10
    id
