fs = require 'fs'

Mocha = require 'mocha'
generateTests = require './generate-tests'

options = require './options'


class Ramlev
  constructor: (config) ->
    @configuration = config

  run: (callback) ->
    config = @configuration

    fs.readFile config.ramlPath, 'utf8', (loadingError, data) ->
      return callback(loadingError, {}) if loadingError

      mocha = new Mocha config.options
      generateTests data, mocha, (error) ->
        console.error(error)
        return callback(error, {}) if error

        mocha.run ->
          callback(null, mocha.reporter.stats)


module.exports = Ramlev
module.exports.options = options
