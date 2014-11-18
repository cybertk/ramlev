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
        test.example = 'E'
        test.schema = 'S'
        sinon.stub test, 'assertExample'

        test.run()
        test.assertExample.should.be.called

      it 'should not modify properties', ->
        test = new Test()
        test.path = '/path'
        test.method = 'M'
        test.status = 200
        test.schema = 'schema'
        test.example = 'example'

        sinon.stub test, 'assertExample'
        assert.equal test.path, '/path'
        assert.equal test.method, 'M'
        assert.equal test.status, 200
        assert.equal test.schema, 'schema'
        assert.equal test.example, 'example'

    describe 'against test skiped', ->
      it 'should not invoke #assertExample', ->
        test = new Test()
        sinon.stub test, 'assertExample'

        test.run()
        test.assertExample.should.not.be.called



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

  describe '#skip', ->

    it 'should return true when test dose not have body and schema', ->
        test = new Test()
        assert.ok test.skip()

    it 'should return false when test does not have body', ->
        test = new Test()
        test.schema = 'SCHEMA'

        assert.notOk test.skip()

    it 'should return false when test does not have schema', ->
        test = new Test()
        test.example = 'BODY'

        assert.notOk test.skip()
