raml = require 'raml-parser'
async = require 'async'
chai = require 'chai'
refaker = require 'refaker'
_ = require 'underscore'

options = require './options'
addTests = require './add-tests'
Runner = require './test-runner'
extractSchemas = require './extract-schemas'


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
        addTests raml, tests, callback
      ,
      # Config refaker
      (callback) ->
        refaker_keys = ['fakeroot', 'directory']
        refaker_opts = _.pick(config.options, refaker_keys)
        refaker _.extend({ schemas: extractSchemas(tests) }, refaker_opts), (err, refs, schemas) ->
          test.json = schemas[test.refaked] for test in tests when test.refaked >= 0
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
