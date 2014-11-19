async = require 'async'
_ = require 'underscore'

Test = require './test'

addTestIfNeeded = (tests, path, method, status, api) ->
    return unless api?.body

    test = new Test

    test.path = path
    test.method = method
    test.status = status

    # Update test.request
    if api.body['application/json']
      test.example = api.body['application/json']?.example
      test.schema = api.body['application/json']?.schema

    # Append new test to tests
    tests.push test


# addTests(raml, tests, [parent], callback)
addTests = (raml, tests, parent, callback) ->

  # Handle 3th optional param
  if _.isFunction(parent)
    callback = parent
    parent = null

  return callback() unless raml.resources

  # Iterate endpoint
  async.each raml.resources, (resource, callback) ->
    path = resource.relativeUri

    # Apply parent properties
    if parent
      path = parent.path + path

    # resource does not define methods
    resource.methods ?= []

    # Iterate response method
    async.each resource.methods, (api, callback) ->
      method = api.method.toUpperCase()
      addTestIfNeeded(tests, path, method, null, api)

      # Iterate response status
      for status, res of api.responses
        addTestIfNeeded(tests, path, method, status, res)

      callback()
    , (err) ->
      return callback(err) if err

      # Recursive
      addTests resource, tests, {path}, callback
  , callback


module.exports = addTests
