raml = require 'raml-parser'
async = require 'async'
chai = require 'chai'
_ = require 'underscore'

options = require './options'
addTests = require './add-tests'
Runner = require './test-runner'
resolveRefs = require './resolve-refs'


class Ramlev
  constructor: (config) ->
    @configuration = config
    @tests = []

  run: (callback) ->
    config = @configuration
    tests = @tests

    async.waterfall [
      # Load RAML
      (callback) ->
        raml.loadFile(config.ramlPath).then (raml) ->
          callback(null, raml)
        , callback
      ,
      # Parse tests from RAML
      (raml, callback) ->
        addTests raml, tests, ->
          callback(null, raml)
      ,
      # Config refaker
      (raml, callback) ->
        options = _.pick(config.options, ['fakeroot', 'directory'])
        resolveRefs raml, tests, options, (err, refs) ->
          # Register any found schema
          chai.tv4.addSchema(id, json) for id, json of refs
          callback()
      ,
      # Run tests
      (callback) ->
        runner = new Runner config.options
        runner.run tests, callback
    ], callback

module.exports = Ramlev
module.exports.options = options
