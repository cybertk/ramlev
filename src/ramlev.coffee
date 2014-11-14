chai = require 'chai'
Mocha = require 'mocha'

_ = require 'underscore'
refaker = require 'refaker'

raml = require 'raml-parser'
generateTests = require './generate-tests'
extractSchemas = require './extract-schemas'

options = require './options'


class Ramlev
  constructor: (config) ->
    @configuration = config

  run: (callback) ->
    config = @configuration

    raml.loadFile(config.ramlPath)
    .then (raml) ->
      refaker_keys = ['fakeroot', 'directory']
      refaker_opts = _.pick(config.options, refaker_keys)

      runTests = (schemas, references) ->
        mocha = new Mocha _.omit(config.options, refaker_keys)
        generateTests raml, mocha, schemas, references
        mocha.run (failures)->
          callback(null, failures)

      try
        params = _.extend
          schemas: extractSchemas(raml)
        , refaker_opts

        refaker params, (err, refs, schemas) ->
          if err then callback(err, {}) else runTests(schemas, _.extend({}, config.refs, refs))
      catch e
        callback(e, {})
    , (error) ->
      return callback(error, {})

module.exports = Ramlev
module.exports.options = options
