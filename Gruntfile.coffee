module.exports = (grunt) ->

  require('time-grunt') grunt

  ###
  Dynamically load npm tasks
  ###
  require('jit-grunt') grunt

  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-mocha-test');

  grunt.initConfig

    # Watching changes files *.js,
    watch:
      all:
        files: [
          "Gruntfile.coffee"
          "src/*.coffee"
        ]
        tasks: [
          "coffee"
        ]
        options:
          nospawn: true

    coffee:
      compile:
        expand: true,
        flatten: true,
        src: ['src/*.coffee'],
        dest: 'lib/',
        ext: '.js'

    mochaTest:
      test:
        options:
          require: 'coffee-script/register'
        src: ['test/**/*.coffee']

  grunt.registerTask "default", [
    "watch"
  ]

  grunt.registerTask "test", [
    "coffee"
    "mochaTest"
  ]

  return
