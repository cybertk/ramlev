_ = require 'underscore'

module.exports = extractSchemas = (tests) ->
  retval = []
  
  _.each tests, (test) ->
    retval.push(JSON.parse test.schema) if test.schemaVersion() is 'jsonschema-draft-4'

  retval
