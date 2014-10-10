mongo = require '../../lib-js/mongo'
_ = require 'underscore'

module.exports = (app, db) ->
  app.get '/user/:user_id', (req, res) ->
    mongo.lookup_by_id db, req.params.user_id, (err, user) ->
      _.extend req.query, {name: user[0].name, user_id: user[0].user_id}
      res.render 'user/index', req.query

  app.post '/user/:user_id', (req, res) ->
    mongo.add_event db, req.params.user_id, req.body, (err, user) ->
      return res.redirect "/user/#{req.params.user_id}?suc=Event add successful!" if _.isNull err
      res.redirect "/user/#{req.params.user_id}?err=Event add failed!"

