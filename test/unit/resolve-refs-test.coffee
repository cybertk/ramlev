{assert} = require 'chai'
ramlParser = require 'raml-parser'

addTests = require '../../lib/add-tests'
resolveRefs = require '../../lib/resolve-refs'

describe '#resolveRefs', ->

  describe 'when raml contains schemas with references', ->

    refs = {}
    tests = []
    callback = null

    before (done) ->
      ramlParser.loadFile("#{__dirname}/../fixtures/include_local_refs_inline.raml")
      .then (data) ->
        options =
          fakeroot: 'http://json-schema.org'
          directory: __dirname + '/../fixtures'

        callback = (err, schemas) ->
          refs = schemas
          done()

        addTests data, tests, ->
          resolveRefs data, tests, options, callback
      , done

    after ->
      refs = {}
      tests = []

    it 'should resolve 2 schemas', ->
      assert.lengthOf Object.keys(refs), 2
