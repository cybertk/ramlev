chai = require 'chai'
csonschema = require 'csonschema'
_ = require 'underscore'

assert = chai.assert
chai.use(require 'chai-json-schema')


class Test
  constructor: () ->
    @path = ''
    @method = ''
    @status = 0
    @schema = ''
    @example = ''

  name: ->
    if @status
      "#{@method} response #{@status}"
    else
      "#{@method} request"

  skip: ->
    return false if @schema and @example
    true

  schemaVersion: ->
    # JSON-schema in RAML are always objects so..
    if /^[^{]*\{[\s\S]*\}[^}]*/.test(@schema)
      'jsonschema-draft-4'
    else
      'csonschema'

  run: ->
    @assertExample() unless @skip()

  parseSchema: ->
    switch @schemaVersion()
      when 'jsonschema-draft-4' then JSON.parse @schema
      when 'csonschema' then csonschema.parse @schema
      else throw new Error('Unsupported schema')

  assertExample: ->
    schema = @json or @parseSchema()
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
