_ = require 'underscore'
express = require 'express'
fs = require 'fs'
body_parser = require 'body-parser'

mongo = require './lib-js/mongo'

# Setup
app = express()
# all res.render is relative to this
# all links to css/js is also relative to this (I think...)
app.set 'views', '/home/christopher/code/time/build/pages'
app.set 'view engine', 'jade'
app.locals.pretty = true

# Where are these files?
app.use "/", express.static('/home/christopher/code/time/build/pages')

#_.each fs.readdirSync('./pages'), (page) ->
  #app.use "/#{page}", express.static("/home/christopher/code/time/build/pages/#{page}")

# Middleware
app.use body_parser.urlencoded({ extended: false })

mongo.connect (err, db) ->
  throw err if err

  # Routes
  _.each fs.readdirSync('./pages'), (page) ->
    require("./pages/#{page}/routes") app, db

  server = app.listen 8080, ->
    console.log 'listening on port 8080'
