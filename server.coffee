_ = require 'underscore'
express = require 'express'
fs = require 'fs'
body_parser = require 'body-parser'
cookie_parser = require 'cookie-parser'
session = require 'express-session'

mongo = require './lib-js/mongo'

PORT = 8080
DB = if process.argv[2] is 'prod' then 'prod-time' else 'dev-time'

# Setup
app = express()

# I am pretty sure this is just what res.render is relative to
app.set 'views', 'pages'
app.set 'view engine', 'jade'
app.locals.pretty = true

# This appears to over-ride the app.set views
app.use express.static("#{__dirname}/pages")
app.use '/public', express.static("#{__dirname}/public")


# Middleware
app.use body_parser.urlencoded({ extended: false })
app.use cookie_parser()
app.use session({secret: 'something', saveUninitialized: true, resave: true})

mongo.connect DB, (err, db) ->
  throw err if err

  # Routes
  _.each fs.readdirSync('./pages'), (page) ->
    require("./pages/#{page}/routes") app, db

  server = app.listen PORT, ->
    console.log "listening on port #{PORT}"
