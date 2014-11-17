chai = require 'chai'
csonschema = require 'csonschema'
_ = require 'underscore'

assert = chai.assert
chai.use(require 'chai-json-schema')


String::contains = (it) ->
  @indexOf(it) != -1

class Test
  constructor: () ->
    @name = ''
    @skip = false

    @schema = ''
    @example = ''

  run: ->
    @assertExample()

  parseSchema: (source) =>
    console.log typeof(source), source
    if source.contains('$schema')
      # jsonschema draft 4 only
      JSON.parse source
    else
      # csonschema
      csonschema.parse source

  assertExample: =>
    schema = @parseSchema(@schema)
    validateJson = _.partial(JSON.parse, @example)
    assert.doesNotThrow validateJson, JSON.SyntaxError, """
      Invalid JSON:
      #{json}
      Error
    """

    json = validateJson()
    assert.jsonSchema json, schema, """
      Got unexpected response body:
      #{JSON.stringify(json, null, 4)}
      Error
    """

module.exports = Test
