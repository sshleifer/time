# Contains the functions that deal with the database
h = require './helpers'
_ = require 'underscore'

module.exports =
  connect: (cb) ->
    MongoClient = require('mongodb').MongoClient
    MongoClient.connect 'mongodb://127.0.0.1:27017/time', (err, db) ->
      return cb err if err
      return cb null, db.collection('time')


  create_user: (collection, params, cb) ->
    params.user_id = h.generate_userid params.user_id
    return cb 'invalid id' if _.isNull params.user_id
    collection.find({user_id: params.user_id}).toArray (err, res) =>
      return collection.insert params, cb if _.isEmpty res
      return cb 'id already taken' if params.user_id
      @create_user collection, params, cb

  lookup_by_id: (collection, user_id, cb) ->
    collection.find({user_id}).toArray cb

  add_event: (collection, user_id, event, cb) ->
    event = h.correct_timezone event
    collection.update {user_id}, {$addToSet: {events: event}}, cb

  test: ->
    return 4
