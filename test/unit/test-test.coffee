chai = require 'chai'
sinon = require 'sinon'
sinonChai = require 'sinon-chai'
_ = require 'underscore'
proxyquire = require('proxyquire').noCallThru()

assert = chai.assert
should = chai.should()
chai.use(sinonChai);

Test = proxyquire '../../src/test', {
}


describe 'Test', ->

  describe '#run', ->

    describe 'of simple test', ->

      it 'should invoke #assertExample', ->
        test = new Test()
        sinon.stub test, 'assertExample'

        test.run()
        test.assertExample.should.be.called

      it 'should not modify properties', ->
        test = new Test()
        test.name = 'Test it'
        test.schema = 'schema'
        test.example = 'example'

        sinon.stub test, 'assertExample'
        assert.equal test.name, 'Test it'
        assert.equal test.schema, 'schema'
        assert.equal test.example, 'example'


  describe '#assertExample', ->
    describe 'when against valid example', ->
      it 'should should pass all asserts', ->
        test = new Test()
        test.schema = JSON.stringify
          $schema: 'http://json-schema.org/draft-04/schema#'
          type: 'object'
          properties:
            name:
              type: 'string'
        test.example = JSON.stringify
          name: 'foo'
        test.assertExample()

    describe 'when example is null', ->

      it 'should throw AssertionError', ->
        test = new Test()
        test.schema = JSON.stringify
          $schema: 'http://json-schema.org/draft-04/schema#'
          type: 'object'
          properties:
            name:
              type: 'string'
        assert.throw test.assertExample, chai.AssertionError

    describe 'when example is invalid json', ->
      it 'should throw AssertionError', ->
        test = new Test()
        test.schema = JSON.stringify
          $schema: 'http://json-schema.org/draft-04/schema#'
          type: 'object'
          properties:
            name:
              type: 'string'
        test.example = '{"a": invalid[]}'
        assert.throw test.assertExample, chai.AssertionError

    describe 'when example does not lint with schema', ->
      it 'should throw AssertionError', ->
        test = new Test()
        test.schema = JSON.stringify
          $schema: 'http://json-schema.org/draft-04/schema#'
          type: 'object'
          properties:
            name:
              type: 'string'
        test.example = JSON.stringify
          name: 1
        assert.throw test.assertExample, chai.AssertionError
