mongo = require '../../lib-js/mongo'
_ = require 'underscore'

module.exports = (app, db) ->

  app.get '/user/:user_id', (req, res) ->
    mongo.lookup_by_id db, req.params.user_id, (err, user) ->
      return res.render 'user/not_found' if _.isEmpty user
      res.render 'user/index', _.extend req.query, {name: user[0].name, user_id: user[0].user_id}

  app.post '/user/add_event/:user_id', (req, res) ->
    _.extend req.session, {last_added: req.body}
    mongo.add_event db, req.params.user_id, req.body, (err, resp) ->
      return res.redirect "/user/#{req.params.user_id}?err=Event add failed!" if err
      res.redirect "/user/#{req.params.user_id}?suc=Event add successful!"

  app.post '/user/undo/:user_id', (req, res) ->
    mongo.remove_event db, req.params.user_id, req.session.last_added, (err, resp) ->
      res.type('json')
      return res.status(400).send(JSON.stringify("Failed!")) if err
      return res.status(404).send(JSON.stringify("Event not found")) if resp is 0
      res.status(200).send(JSON.stringify("Event removed!"))
