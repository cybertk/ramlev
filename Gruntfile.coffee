module.exports = (grunt) ->

  require('time-grunt') grunt

  # Dynamically load npm tasks
  require('jit-grunt') grunt

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

    coffeecov:
      compile:
        src: 'src'
        dest: 'lib'

    mochaTest:
      test:
        options:
          reporter: 'mocha-phantom-coverage-reporter'
          require: 'coffee-script/register'
        src: ['test/**/*.coffee']

    shell:
      coveralls:
        command: 'cat coverage/coverage.lcov | ./node_modules/coveralls/bin/coveralls.js src'

  grunt.registerTask 'uploadCoverage', ->
    return grunt.log.ok 'Bypass uploading' unless process.env['CI'] is 'true'

    grunt.task.run 'shell:coveralls'

  grunt.registerTask "default", [
    "watch"
  ]

  grunt.registerTask "test", [
    "coffeecov"
    "mochaTest"
    "uploadCoverage"
  ]

  return
