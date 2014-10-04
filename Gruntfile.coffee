_ = require 'underscore'

module.exports = (grunt) ->
  grunt.initConfig

    pkg: grunt.file.readJSON 'package.json'

    coffee:
      # Compiles routes coffeescript
      routes:
        expand: true
        cwd: 'pages'
        src: ['*/routes.coffee']
        dest: 'build/pages'
        ext: '.js'
      # Compiles backend coffeescript
      backend:
        expand: true
        cwd: 'lib'
        src: ['*.coffee']
        dest: 'build/lib-js'
        ext: '.js'
      # Compiles frontend coffeescript
      # Also compiles server
      compile:
        files:
          'build/server.js': 'server.coffee'
          'build/pages/user_home/scripts/main.js': 'pages/user_home/scripts/main.coffee'
          'build/pages/homepage/scripts/main.js': 'pages/homepage/scripts/main.coffee'
          'build/pages/blog/scripts/main.js': 'pages/blog/scripts/main.coffee'
          'build/pages/signup/scripts/main.js': 'pages/signup/scripts/main.coffee'

    less:
      prod:
        files:
          'build/pages/user_home/styles/main.css': 'pages/user_home/styles/main.less'
          'build/pages/homepage/styles/main.css': 'pages/homepage/styles/main.less'
          'build/pages/blog/styles/main.css': 'pages/blog/styles/main.less'
          'build/pages/signup/styles/main.css': 'pages/signup/styles/main.less'

    # Copy over the public resources as well as the jade
    copy:
      main:
        files: [
          {
            expand: true
            cwd: 'pages/public'
            src: ['**']
            dest: 'build/pages/public'
          }
          {
            expand: true
            cwd: 'pages'
            src: ['*/*.jade']
            dest: 'build/pages'
          }
        ]
        

    concurrent:
      exec_watch:
        tasks: ['nodemon', 'watch']
        options:
          logConcurrentOutput: true

    nodemon:
      dev:
        script: 'build/server.js'

    watch:
      files: ['**/*']
      tasks: ['default']

    clean:
      ['build']

  _.each ['coffee', 'watch', 'copy', 'less', 'clean'], (task) ->
    grunt.loadNpmTasks 'grunt-contrib-' + task
  grunt.loadNpmTasks 'grunt-concurrent'
  grunt.loadNpmTasks 'grunt-nodemon'

  grunt.registerTask 'default', ['clean', 'coffee', 'copy', 'less']
  grunt.registerTask 'dev-server', ['default', 'concurrent:exec_watch']
