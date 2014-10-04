mongo = require '../../lib-js/mongo'

module.exports = (app, db) ->
  app.get '/signup', (req, res) ->
    res.render 'signup/index'

  app.post '/signup', (req, res) ->
    mongo.create_user db, req.body.name, req.body.email, (err, user) ->
      res.render 'signup/success', id: user[0].user_id

