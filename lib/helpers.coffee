module.exports =
  
  generate_userid: ->
    shorturl = Math.random().toString(36)[2..11]
    return shorturl if shorturl.length is 10
    @generate_userid()
