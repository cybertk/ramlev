_ = require 'underscore'

id = 0

hash = ->
  "schema_#{id++}"

module.exports = extractSchemas = (tests) ->
  retval = []

  _.each tests, (test) ->
    unless test.skip()
      schema = test.parseSchema()
      schema.$offset = test.$offset = hash()

      retval.push(schema)

  retval
