async = require 'async'
_ = require 'underscore'

Test = require './test'

addTestIfNeeded = (tests, path, method, status, api) ->
    return unless api?.body

    jsonMimeTypes = (mimeType for mimeType of api.body when mimeType.match(/application\/(.+\+)*json/))
    if jsonMimeTypes.length == 0
      test = new Test
      test.path = path
      test.method = method
      test.status = status
      # Add skipped test
      tests.push test
    else
      for type in jsonMimeTypes
        test = new Test
        test.path = path
        test.method = method
        test.status = status
        test.mimeType = type
        test.example = api.body[type].example
        test.schema = api.body[type].schema
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
