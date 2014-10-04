_ = require 'underscore'

module.exports = (grunt) ->
  grunt.initConfig

    pkg: grunt.file.readJSON 'package.json'

    coffee:
      # Needs to be first as other things require it
      lib:
        expand: true
        cwd: 'lib/'
        src: ['*.coffee']
        dest: 'build/lib-js'
        ext: '.js'
      server:
        files:
          'build/server.js': 'server.coffee'
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
            cwd: 'pages/public'
            src: ['**']
            dest: 'build/pages/public'
          }
          {
            expand: true
            cwd: 'pages'
            src: ['**/*.jade']
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
      files: ['lib/**', 'pages/**', 'server.js']
      tasks: ['default']

    clean:
      ['build']

  _.each ['coffee', 'watch', 'copy', 'less', 'clean'], (task) ->
    grunt.loadNpmTasks 'grunt-contrib-' + task
  grunt.loadNpmTasks 'grunt-concurrent'
  grunt.loadNpmTasks 'grunt-nodemon'

  grunt.registerTask 'default', ['clean', 'coffee', 'copy', 'less']
  grunt.registerTask 'dev-server', ['default', 'concurrent:exec_watch']
