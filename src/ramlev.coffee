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
        addTests raml, tests, ->
          callback(null, raml)
      ,
      # Config refaker
      (raml, callback) ->
        refaker_keys = ['fakeroot', 'directory']
        refaker_opts = _.pick(config.options, refaker_keys)

        # strategy for faked-schemas
        refaker_opts.schemas = []

        # extract schemas from defined tests (resources)
        raml_schemas = extractSchemas(tests)

        push = (schema) ->
          # avoid duplicates!
          if refaker_opts.schemas.indexOf(schema) is -1
            refaker_opts.schemas.push(schema)

        # collect resource-schemas
        _.each raml_schemas, push

        # collect raml-schemas
        _.each raml.schemas, (obj) ->
          _.each _.map(_.values(obj), JSON.parse), push

        refaker refaker_opts, (err, refs, schemas) ->
          fixed_schemas = {}

          # collect all normalized schemas
          _.each schemas, (schema) ->
            fixed_schemas[schema.$offset] = schema
            delete schema.$offset

          # inject the normalized schema into the test
          test.json = fixed_schemas[test.$offset] for test in tests when test.$offset

          for id, json of refs
            delete json.$offset
            chai.tv4.addSchema(id, json)

          callback()
      ,
      # Run tests
      (callback) ->
        runner = new Runner config.options
        runner.run tests, callback
    ], callback

module.exports = Ramlev
module.exports.options = options
