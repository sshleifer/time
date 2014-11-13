###
The only functions that touch the database
###

h = require './helpers'
_ = require 'underscore'
async = require 'async'

# Private general functions. User should call the funcs specific to their task
m_helpers =
  _sth_by_id: (db, user_id, sth, cb) ->
    async.waterfall [
      (cb_wf) => @user_by_id db, user_id, cb_wf
      (res, cb_wf) -> db.collection(sth).find({_id: res[sth]}).toArray cb_wf
    ], (err, res) ->
      cb err, if res[0]? then res[0] else null

  _add_sth: (db, user_id, to_add, sth, cb) ->
    @_sth_by_id db, user_id, sth, (err, res) ->
      to_add.id = res.last_id + 1
      db.collection(sth).update {_id: res._id}, {$set: {last_id: to_add.id}}, (err, a, b) ->
        to_update = {}
        to_update["#{sth}"] = to_add
        db.collection(sth).update {_id: res._id}, {$addToSet: to_update}, {upsert: true}, cb

  # To_remove is just a query
  _remove_sth: (db, user_id, to_remove, sth, cb) ->
    @_sth_by_id db, user_id, sth, (err, res) ->
      to_update = {}
      to_update["#{sth}"] = to_remove
      db.collection(sth).update {_id: res._id}, {$pull: to_update}, cb

users =
  create_user: (db, params, cb) ->
    users_db = db.collection('users')
    user_id = h.generate_userid params.user_id
    return cb 'invalid id' if _.isNull user_id

    async.waterfall [
      (cb_wf) -> users_db.find({user_id}).toArray cb_wf
      (res, cb_wf) =>
        return cb_wf() if _.isEmpty res
        return cb 'id already taken' if params.user_id
        @create_user db, params, cb
      (cb_wf) -> db.collection('events').insert {last_id: -1}, cb_wf
      (res, cb_wf) -> users_db.insert _.extend(_.clone(params), {events: res[0]._id, user_id}), cb_wf
      (res, cb_wf) -> db.collection('todos').insert {last_id: -1}, cb_wf
      (res, cb_wf) -> users_db.update {user_id}, {$set: {todos: res[0]._id}}, cb_wf
      (res, res2, cb_wf) -> users_db.find({user_id}).toArray cb_wf
    ], (err, user) ->
      cb err, user if user?

  user_by_id: (db, user_id, cb) ->
    users = db.collection('users')
    users.find({user_id}).toArray (err, res) ->
      cb err, if res[0]? then res[0] else null

events =
  events_by_id: (db, user_id, cb) ->
    @_sth_by_id db, user_id, 'events', cb

  add_event: (db, user_id, event, cb) ->
    @_add_sth db, user_id, event, 'events', cb

  remove_event: (db, user_id, event, cb) ->
    @_remove_sth db, user_id, event, 'events', cb

todos =
  todos_by_id: (db, user_id, cb) ->
    @_sth_by_id db, user_id, 'todos', cb


  add_todo: (db, user_id, todo, cb) ->
    todo.estimated_time = todo.estimated_time * 60 if todo.units is 'hours'
    delete todo.units
    @_add_sth db, user_id, todo, 'todos', cb

  remove_todo: (db, user_id, todo, cb) ->
    @_remove_sth db, user_id, todo, 'todos', cb

misc =
  connect: (name, cb) ->
    MongoClient = require('mongodb').MongoClient
    MongoClient.connect "mongodb://127.0.0.1:27017/#{name}", (err, db) ->
      return cb err if err
      return cb null, db

_.extend(module.exports, users, events, todos, misc, m_helpers)
