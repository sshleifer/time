mongo = require '../../lib-js/mongo'

module.exports = (app, db) ->
  app.get '/signup', (req, res) ->
    res.render 'signup/index', req.query

  app.get '/signup/success', (req, res) ->
    res.render 'signup/success', req.query

  app.post '/signup', (req, res) ->
    mongo.create_user db, req.body, (err, user) ->
      return res.redirect "/signup?err=#{err}" if err
      res.redirect "/signup/success?id=#{user[0].user_id}"

