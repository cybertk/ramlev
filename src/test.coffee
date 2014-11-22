chai = require 'chai'
csonschema = require 'csonschema'
CSON = require 'cson-safe'
_ = require 'underscore'

assert = chai.assert
chai.use(require 'chai-json-schema')


String::contains = (it) ->
  @indexOf(it) != -1

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
    if @schema?.contains('$schema')
      'jsonschema-draft-4'
    else
      'csonschema'

  run: ->
    @assertExample() unless @skip()

  parseSchema: (source) =>
    switch @schemaVersion()
      when 'jsonschema-draft-4' then JSON.parse source
      when 'csonschema' then csonschema.parse source
      else throw new Error('Unsupported schema')

  parseExample: (source) =>
    # Parse as CSON first
    try
      source = CSON.parse source

    # fallback to json
    source

  assertExample: =>
    schema = @parseSchema(@schema)

    try
      console.log 'a'
      json = CSON.parse @example
      console.log 'b'
    catch e
      console.log 'ck', e
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
