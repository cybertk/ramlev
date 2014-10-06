chai = require 'chai'
Mocha = require 'mocha'
raml = require 'raml-parser'
generateTests = require './generate-tests'

options = require './options'


class Ramlev
  constructor: (config) ->
    @configuration = config

  run: (callback) ->
    config = @configuration

    chai.tv4.addSchema(id, json) for id, json of config.refs if config.refs

    raml.loadFile(config.ramlPath)
    .then (raml) ->
      mocha = new Mocha config.options
      generateTests raml, mocha
      mocha.run ->
        callback(null, mocha.reporter.stats)

    , (error) ->
      return callback(error, {})


module.exports = Ramlev
module.exports.options = options
