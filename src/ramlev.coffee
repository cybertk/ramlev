fs = require 'fs'

Mocha = require 'mocha'
generateTests = require './generate-tests'


options = require './options'

class Ramlev
  constructor: (config) ->
    @tests = []
    @stats =
        tests: 0
        failures: 0
        errors: 0
        passes: 0
        skipped: 0
        start: 0
        end: 0
        duration: 0
    @configuration = config
  run: (callback) ->
    config = @configuration
    stats = @stats

    fs.readFile config.ramlPath, 'utf8', (loadingError, data) ->
      return callback(loadingError, stats) if loadingError

      mocha = new Mocha config.options
      generateTests data, mocha, ->
        mocha.run ->
          callback(null, mocha.reporter.stats)


module.exports = Ramlev
module.exports.options = options
