# Contains the functions that deal with the database
h = require './helpers'
_ = require 'underscore'
async = require 'async'

module.exports =
  connect: (cb) ->
    MongoClient = require('mongodb').MongoClient
    MongoClient.connect 'mongodb://127.0.0.1:27017/time', (err, db) ->
      return cb err if err
      return cb null, db


  create_user: (db, params, cb) ->
    users = db.collection('users')
    events = db.collection('events')
    user_id = h.generate_userid params.user_id
    return cb 'invalid id' if _.isNull user_id

    async.waterfall [
      (cb_wf) -> users.find({user_id}).toArray cb_wf
      (res, cb_wf) =>
        return cb_wf() if _.isEmpty res
        return cb 'id already taken' if params.user_id
        @create_user db, params, cb
      (cb_wf) -> events.insert {}, cb_wf
      (res, cb_wf) -> users.insert _.extend(params, {events: res[0]._id, user_id}), cb_wf
    ], (err, user) ->
      cb err, user if user?

  lookup_by_id: (db, user_id, cb) ->
    users = db.collection('users')
    users.find({user_id}).toArray cb

  add_event: (db, user_id, event, cb) ->
    users = db.collection('users')
    events = db.collection('events')
    async.waterfall [
      (cb_wf) -> users.find({user_id}).toArray cb_wf
      (user, cb_wf) ->
        events.update {_id: user[0].events}, {$addToSet: {events: event}}, {upsert: true}, cb_wf
    ], (err, res) ->
      cb err, res if res?

  remove_event: (db, user_id, event, cb) ->
    users = db.collection('users')
    events = db.collection('events')
    async.waterfall [
      (cb_wf) -> users.find({user_id}).toArray cb_wf
      (user, cb_wf) ->
        events.update {events: event}, {$pull: {events: event}}, cb_wf
    ], (err, res) ->
      cb err, res if res?
