_ = require 'underscore'

module.exports = (grunt) ->
  watchlist = ['lib/**', 'pages/**', 'server.coffee', 'public/**']

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    coffee:
      server:
        files:
          'build/server.js': 'server.coffee'
      lib:
        expand: true
        cwd: 'lib/'
        src: ['*.coffee']
        dest: 'build/lib-js'
        ext: '.js'
      routes:
        expand: true
        cwd: 'pages/'
        src: ['*/routes.coffee']
        dest: 'build/pages/'
        ext: '.js'
      browser:
        expand: true
        cwd: 'pages/'
        src: ['**/scripts/*.coffee']
        dest: 'build/pages/'
        ext: '.js'

    browserify:
      browser:
        src: ['build/pages/user/scripts/main.js']
        dest: 'build/pages/user/scripts/main.js'

    less:
      browser:
        expand: true
        cwd: 'pages/'
        src: ['**/styles/*.less']
        dest: 'build/pages/'
        ext: '.css'

    # Copy over the public resources as well as the jade
    copy:
      main:
        files: [
          {
            expand: true
            cwd: 'pages'
            src: ['**/*.jade']
            dest: 'build/pages'
          }
          {
            expand: true
            cwd: 'public'
            src: ['scripts/*.js', 'jade/*.jade']
            dest: 'build/public'
          }
          {
            expand: true
            cwd: 'public'
            src: ['resources/*']
            dest: 'build/public'
          }
        ]
        
    clean:
      ['build']

    concurrent:
      dev:
        tasks: ['nodemon', 'watch']
        options:
          logConcurrentOutput: true

    nodemon:
      dev:
        script: 'build/server.js'
        options:
          delay: 1000
          watch: watchlist
          ext: 'js,coffee,jade,less'

    watch:
      files: watchlist
      tasks: ['default']


  _.each ['coffee', 'watch', 'copy', 'less', 'clean'], (task) ->
    grunt.loadNpmTasks 'grunt-contrib-' + task

  _.each ['concurrent', 'nodemon', 'browserify'], (task) ->
    grunt.loadNpmTasks 'grunt-' + task

  grunt.registerTask 'default', ['copy', 'less', 'coffee', 'browserify']
  grunt.registerTask 'dev-server', ['default', 'concurrent:dev']
