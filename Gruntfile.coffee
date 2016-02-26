module.exports = (grunt) ->

  require('time-grunt') grunt

  # Dynamically load npm tasks
  require('jit-grunt') grunt

  grunt.initConfig

    # Watching changes files *.coffee,
    watch:
      all:
        files: [
          "Gruntfile.coffee"
          "lib/*.coffee"
        ]
        options:
          nospawn: true

    coffeecov:
      compile:
        src: 'lib'
        dest: 'lib'

    mochaTest:
      test:
        options:
          reporter: 'mocha-phantom-coverage-reporter'
          require: 'coffee-script/register'
        src: [
          'test/**/*.coffee',
          'test/acceptance/lib-test.js'
        ]

    shell:
      coveralls:
        command: 'cat coverage/coverage.lcov | ./node_modules/coveralls/bin/coveralls.js lib'

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
