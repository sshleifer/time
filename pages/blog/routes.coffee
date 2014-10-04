module.exports = (app) ->

  app.get '/blog', (req, res) ->
    res.render 'blog/index'
