Mocha = require 'mocha'
Test = Mocha.Test
Suite = Mocha.Suite

raml = require 'raml-parser'
chai = require 'chai'
jsonlint = require 'jsonlint'
_ = require 'underscore'

chai.should()
chai.use(require 'chai-json-schema')


_validatable = (body) ->

  return false if not body

  json = body['application/json']
  return false if not json

  return true if json.example and json.schema
  false


_validate = (body) ->

  example = jsonlint.parse body['application/json'].example
  schema = jsonlint.parse body['application/json'].schema
  example.should.be.jsonSchema schema


_traverse = (ramlObj, parentUrl, parentSuite) ->

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
        suite.addTest new Test "#{method.toUpperCase()} request", ->
          _validate endpoint.body

      # Response
      if not endpoint.responses
        suite.addTest new Test "#{method.toUpperCase()} response"

      for status, res of endpoint.responses

        if not res or not _validatable(res.body)
          suite.addTest new Test "#{method.toUpperCase()} response #{status}"
        else
          suite.addTest new Test "#{method.toUpperCase()} response #{status}", _.bind ->
            _validate this.body
          , { body: res.body}

    _traverse resource, url, parentSuite


generateTests = (source, mocha, callback) ->

  raml.load(source).then (raml) ->

    _traverse raml, '', mocha.suite

    callback()
  , callback


module.exports = generateTests
