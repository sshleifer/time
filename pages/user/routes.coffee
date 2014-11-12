mongo = require '../../lib-js/mongo'
console.log mongo
_ = require 'underscore'

module.exports = (app, db) ->

  app.get '/user/:user_id', (req, res) ->
    mongo.user_by_id db, req.params.user_id, (err, user) ->
      return res.render 'user/not_found' if _.isEmpty user
      res.render 'user/index', _.extend req.query, {name: user.name, user_id: user.user_id}


  app.post '/user/add_event/:user_id', (req, res) ->
    _.extend req.session, {last_added: req.body}
    mongo.add_event db, req.params.user_id, req.body, (err, resp) ->
      return res.redirect "/user/#{req.params.user_id}?err=Event add failed!" if err
      res.redirect "/user/#{req.params.user_id}?suc=Event add successful!"

  app.post '/user/undo_event/:user_id', (req, res) ->
    mongo.remove_event db, req.params.user_id, req.session.last_added, (err, resp) ->
      res.type('json')
      return res.status(400).send(JSON.stringify("Failed!")) if err
      return res.status(404).send(JSON.stringify("Event not found")) if resp is 0
      res.status(200).send(JSON.stringify("Event removed!"))


  app.post '/user/add_todo/:user_id', (req, res) ->
    mongo.add_todo db, req.params.user_id, req.body, (err, resp) ->
      res.redirect "/user/#{req.params.user_id}"

  app.post '/user/remove_todo/:user_id', (req, res) ->
    console.log req.params, req.body
    mongo.remove_todo db, req.params.user_id, {id: parseInt(req.body.id.split(' ')[1])}, (err, resp) ->
      return res.status(200).end() if _.isNull err

  app.post '/user/lookup_todo/:user_id', (req, res) ->
    mongo.todos_by_id db, req.params.user_id, (err, resp) ->
      console.log resp
      res.type('json')
      return res.status(400).send(JSON.stringify("Failed!")) if err
      res.status(200).send(JSON.stringify(if resp?.todos? then resp.todos else []))
