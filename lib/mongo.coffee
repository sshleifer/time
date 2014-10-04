# Contains the functions that deal with the database
h = require './helpers'
_ = require 'underscore'

module.exports =
  connect: (cb) ->
    MongoClient = require('mongodb').MongoClient
    MongoClient.connect 'mongodb://127.0.0.1:27017/time', (err, db) ->
      return cb err if err
      return cb null, db.collection('time')


  create_user: (collection, name, email, cb) ->
    user_id = h.generate_userid()
    collection.find({user_id}).toArray (err, res) =>
      if _.isEmpty res
        collection.insert {name, email, user_id}, cb
      else
        @create_user collection, name, email, cb

  test: ->
    return 4
