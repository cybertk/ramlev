_ = require 'underscore'

module.exports = extractSchemas = (tests) ->
  retval = []

  _.each tests, (test) ->
    test.refaked = retval.push(JSON.parse test.schema) - 1 if test.schemaVersion() is 'jsonschema-draft-4' and !test.skip()

  retval
