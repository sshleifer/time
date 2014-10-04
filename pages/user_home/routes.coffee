module.exports = (app) ->

  app.get '/my_string', (req, res) ->
    res.render 'user_home/index'
