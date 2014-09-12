require('chai').should()

Mocha = require 'mocha'
Test = Mocha.Test
Suite = Mocha.Suite

raml = require 'raml-parser'
validate = require('tv4').validate

_generateTests = (source, mocha, callback) ->

  raml.load(source).then (raml) ->
    console.log(raml)

    suite = Suite.create mocha.suite, 'I am a dynamic suite'
    suite.addTest new Test 'I am a dynamic test', ->
      true.should.equal true

    callback()
  , (error) ->
    console.log(error)
    callback()

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
      suite.addTest new Test "#{method.toUpperCase()} request", ->
        validate()
        true.should.equal true

      # Response
      if not endpoint.responses
        suite.addTest new Test "#{method.toUpperCase()} response"

      for status, body of endpoint.responses
        console.error(status, body)

        suite.addTest new Test "#{method.toUpperCase()} response #{status}", ->
          true.should.equal true

    _traverse resource, url, parentSuite

generateTests = (source, mocha, callback) ->

  raml.load(source).then (raml) ->

    _traverse raml, '', mocha.suite

    callback()
  , (error) ->
    console.log(error)
    callback()


module.exports = generateTests
