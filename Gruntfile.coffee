_ = require 'underscore'

module.exports = (grunt) ->
  watchlist = ['lib/**', 'pages/**', 'server.coffee', 'public/**']
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    coffee:
      # Needs to be first as other things require it
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
  grunt.loadNpmTasks 'grunt-concurrent'
  grunt.loadNpmTasks 'grunt-nodemon'

  grunt.registerTask 'default', ['clean', 'coffee', 'copy', 'less']
  grunt.registerTask 'dev-server', ['default', 'concurrent:dev']
