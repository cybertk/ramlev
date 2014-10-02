fs = require 'fs'

chai = require 'chai'
Mocha = require 'mocha'
generateTests = require './generate-tests'

options = require './options'


class Ramlev
  constructor: (config) ->
    @configuration = config

  run: (callback) ->
    config = @configuration

    chai.tv4.addSchema(id, json) for id, json of config.refs if config.refs

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
