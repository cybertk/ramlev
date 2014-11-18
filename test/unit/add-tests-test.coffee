{assert} = require 'chai'
sinon = require 'sinon'
ramlParser = require 'raml-parser'

proxyquire = require('proxyquire').noCallThru()

TestStub = require '../../lib/test'
addTests = proxyquire '../../lib/add-tests', {
  './test': TestStub
}

describe '#addTests', ->

  describe '#run', ->

    describe 'when raml contains single get', ->

      tests = []
      callback = ''

      before (done) ->

        ramlParser.loadFile("#{__dirname}/../fixtures/single-get.raml")
        .then (data) ->
          callback = sinon.spy -> done()

          addTests data, tests, callback
        , done
      after ->
        tests = []

      it 'should run callback', ->
        assert.ok callback.called

      it 'should add 1 test', ->
        assert.lengthOf tests, 1

      it 'should setup test', ->
        test = tests[0]

        assert.equal test.path, '/machines'
        assert.equal test.method, 'GET'
        assert.equal test.status, 200
        assert.equal test.example, """
        { "type": "Kulu", "name": "Mike" }

        """
        assert.equal test.schema, """
        [
          type: 'string'
          name: 'string'
        ]

        """
