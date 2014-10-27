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

    chai.tv4.addSchema(id, json) for id, json of config.refs if config.refs

    raml.loadFile(config.ramlPath)
    .then (raml) ->
      refaker_keys = ['fakeroot', 'directory']
      refaker_opts = _.pick(config.options, refaker_keys)

      runTests = ->
        mocha = new Mocha _.omit(config.options, refaker_keys)
        generateTests raml, mocha
        mocha.run (failures)->
          callback(null, failures)

      runTests()
      # try
      #   refaker _.extend({ schemas: extractSchemas(raml) }, refaker_opts), (err, refs) ->
      #     chai.tv4.addSchema(id, json) for id, json of refs
      #
      #     if err
      #       callback(err, {})
      #     else
      #       runTests()
      # catch e
      #   callback(e, {})
    , (error) ->
      return callback(error, {})

module.exports = Ramlev
module.exports.options = options
