mongo = require '../../lib-js/mongo'

module.exports = (app, db) ->

  app.get '/user/:user_id', (req, res) ->
    mongo.lookup_by_id db, req.params.user_id, (err, user) ->
      res.render 'user/index', {name: user[0].name}
