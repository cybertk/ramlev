chai = require 'chai'
csonschema = require 'csonschema'
_ = require 'underscore'

assert = chai.assert
chai.use(require 'chai-json-schema')


String::contains = (it) ->
  @indexOf(it) != -1

class Test
  constructor: () ->
    @path = ''
    @method = ''
    @status = ''
    @schema = ''
    @example = ''

  name: ->
    return ''

  skip: ->
    return true if !@schema and !@example
    false

  run: ->
    @assertExample() unless @skip()

  parseSchema: (source) =>
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
