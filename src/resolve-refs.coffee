_ = require 'underscore'

chai = require 'chai'
refaker = require 'refaker'

id = 0

hash = ->
  "schema_#{id++}"

extractSchemas = (tests) ->
  retval = []

  _.each tests, (test) ->
    unless test.skip()
      schema = test.parseSchema()
      schema.$offset = test.$offset = hash()

      retval.push(schema)

  retval

module.exports = (raml, tests, options, callback) ->
  cache = []

  # strategy for faked-schemas
  options.schemas = []

  # extract schemas from defined tests (resources)
  raml_schemas = extractSchemas(tests)

  push = (schema) ->
    json = JSON.stringify(_.omit(schema, '$offset'))

    # avoid duplicates!
    if cache.indexOf(json) is -1
      options.schemas.push(schema)
      cache.push(json)

  # collect resource-schemas
  _.each raml_schemas, push

  # collect raml-schemas
  _.each raml.schemas, (obj) ->
    _.each _.map(_.values(obj), JSON.parse), push

  refaker options, (err, refs, schemas) ->
    fixed_schemas = {}

    # collect all normalized schemas
    _.each schemas, (schema) ->
      fixed_schemas[schema.$offset] = schema
      delete schema.$offset

    # inject the normalized schema into the test
    test.json = fixed_schemas[test.$offset] for test in tests when test.$offset

    for id, json of refs
      delete json.$offset
      chai.tv4.addSchema(id, json)

    callback()
