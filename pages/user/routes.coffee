mongo = require '../../lib-js/mongo'
_ = require 'underscore'

module.exports = (app, db) ->

  app.get '/user/:user_id', (req, res) ->
    console.log req.query
    mongo.lookup_by_id db, req.params.user_id, (err, user) ->
      res.render 'user/index', user[0]

  app.post '/user/:user_id', (req, res) ->
    mongo.add_event db, req.params.user_id, req.body, (err, user) ->
      if _.isNull err
        res.redirect "/user/#{req.params.user_id}?status=success"
      else
        res.redirect "/user/#{req.params.user_id}?status=failure"

