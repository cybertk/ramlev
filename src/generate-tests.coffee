Mocha = require 'mocha'
chai = require 'chai'
jsonlint = require 'jsonlint'
_ = require 'underscore'
csonschema = require 'csonschema'
refaker = require 'refaker'
extractSchemas = require './extract-schemas'

Test = Mocha.Test
Suite = Mocha.Suite

chai.should()
chai.use(require 'chai-json-schema')

String::contains = (it) ->
  @indexOf(it) != -1

_validatable = (body) ->

  return false unless body and body?['application/json']

  json = body['application/json']
  return true if json.example and json.schema
  false


_validate = (body, schemas) ->
  example = jsonlint.parse body['application/json'].example
  schema = body['application/json'].schema
  if schema.contains('$schema')
    # jsonschema
    schema = jsonlint.parse schema
  else
    # csonschema
    schema = csonschema.parse schema
  # console.error schema
  # if schema?['$schema']
  #   # jsonschema
  #   schema = jsonlint.parse schema
  # else
  #   # csonschema
  #   schema = csonschemaa.parse schema

  example.should.be.jsonSchema schema


_traverse = (ramlObj, parentUrl, parentSuite, fullSchemas) ->

  for i of ramlObj.resources
    resource = ramlObj.resources[i]

    url = parentUrl + resource.relativeUri

    # Generate Test Suite
    suite = Suite.create parentSuite, url

    # Generate Test Cases
    for j of resource.methods

      endpoint = resource.methods[j]
      method = endpoint.method

      # Request
      if not _validatable(endpoint.body)
        suite.addTest new Test "#{method.toUpperCase()} request"
      else
        suite.addTest new Test "#{method.toUpperCase()} request", _.bind ->
          _validate @body, fullSchemas
        , {body: endpoint.body}

      # Response
      if not endpoint.responses
        suite.addTest new Test "#{method.toUpperCase()} response"

      for status, res of endpoint.responses

        if not res or not _validatable(res.body)
          suite.addTest new Test "#{method.toUpperCase()} response #{status}"
        else
          suite.addTest new Test "#{method.toUpperCase()} response #{status}", _.bind ->
            _validate @body, fullSchemas
          , { body: res.body}

    _traverse resource, url, parentSuite, fullSchemas


generateTests = (source, mocha, schemas) ->
  _traverse source, '', mocha.suite, schemas


module.exports = generateTests
