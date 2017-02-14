chai = require 'chai'
csonschema = require 'csonschema'
tv4 = require 'tv4'
_ = require 'underscore'

assert = chai.assert


class Test
  constructor: () ->
    @path = ''
    @method = ''
    @status = 0
    @mimeType = ''
    @schema = ''
    @example = ''

  name: ->
    mimeInformation = ''
    mimeInformation = " - #{@mimeType}" if @mimeType && @mimeType != ''
    if @status
      "#{@method} response #{@status}#{mimeInformation}"
    else
      "#{@method} request#{mimeInformation}"

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
    result = tv4.validateMultiple json, schema
    # console.error "ck", result
    assert.ok result.valid, """
      Got unexpected response body:
      #{JSON.stringify(json, null, 4)}
      Errors:
      #{result.errors}
    """
    assert.lengthOf result.missing, 0, """
      Missing schemas:
      #{result.missing}
    """

module.exports = Test
