chai = require 'chai'
sinon = require 'sinon'
sinonChai = require 'sinon-chai'
_ = require 'underscore'
proxyquire = require('proxyquire').noCallThru()

mocha = require 'mocha'
suiteStub = ''

class TestStub
  name: -> 'FBI'
  skip: -> false
  path: ''

TestRunner = proxyquire '../../lib/test-runner', {
  'mocha': mocha,
}


assert = chai.assert
should = chai.should()
chai.use(sinonChai);

runner = null

describe 'Test Runner', ->

  describe '#run', ->

    describe 'with single valid test', ->

      runner = ''
      callback = ''
      test = ''

      before (done) ->
        runner = new TestRunner
        test = new TestStub
        test.path = '/path'
        callback = sinon.spy -> done()
        mochaStub = runner.mocha
        test.run = sinon.stub()
        sinon.spy mocha.Suite, 'create'
        sinon.stub mochaStub, 'run', (cb) -> cb(0)

        runner.run [test], callback

      after ->
        mochaStub = runner.mocha
        mochaStub.run.restore()
        mocha.Suite.create.restore()

        callback = ''

      it 'should run mocha', ->
        assert.ok runner.mocha.run.calledOnce

      it 'should invoke callback with failures', ->
        callback.should.be.calledWith null, 0

      it 'title of mocha suite should equal test.path', ->
        suites = runner.mocha.suite.suites
        assert.equal suites.length, 1
        assert.equal suites[0].title, '/path'

      it 'title of mocha test should equal test.name', ->
        tests = runner.mocha.suite.suites[0].tests
        assert.equal tests.length, 1
        assert.notOk tests[0].pending
        assert.equal tests[0].title, 'FBI'

      it 'should invoke test.run when mocha.test runs', (done) ->
        mochaTest = runner.mocha.suite.suites[0].tests[0]
        mochaTest.run ->
          test.run.should.be.called
          done()

    describe 'when test is skipped', ->
      before (done) ->
        runner = new TestRunner
        test = new TestStub
        test.path = '/path'
        sinon.stub test, 'skip', -> true
        callback = sinon.spy -> done()
        mochaStub = runner.mocha
        sinon.spy mocha.Suite, 'create'
        sinon.stub mochaStub, 'run', (cb) -> cb(0)

        runner.run [test], callback

      after ->
        runner.mocha.run.restore()
        mocha.Suite.create.restore()

      it 'should run mocha', ->
        assert.ok runner.mocha.run.called

      it 'should setup mocha suite/test properly', ->
        suites = runner.mocha.suite.suites
        assert.equal suites.length, 1
        assert.equal suites[0].title, '/path'

        tests = runner.mocha.suite.suites[0].tests
        assert.equal tests.length, 1
        assert.equal tests[0].title, 'FBI'

      it 'should generated pending mocha test', ->
        tests = runner.mocha.suite.suites[0].tests
        assert.ok tests[0].pending

    describe 'with multiple valid tests', ->

      runner = ''
      callback = ''

      before (done) ->
        runner = new TestRunner

        tests = []
        test1 = new TestStub
        test1.path = '/path'
        tests.push test1

        test2 = new TestStub
        test2.path = '/path'
        tests.push test2

        test3 = new TestStub
        test3.path = '/another-path'
        tests.push test3

        callback = sinon.spy -> done()
        mochaStub = runner.mocha
        sinon.spy mocha.Suite, 'create'
        sinon.stub mochaStub, 'run', (cb) -> cb(0)

        runner.run tests, callback

      after ->
        mochaStub = runner.mocha
        mochaStub.run.restore()
        mocha.Suite.create.restore()

        callback = ''

      it 'should run mocha', ->
        assert.ok runner.mocha.run.calledOnce

      it 'should invoke callback without failures', ->
        callback.should.be.calledWith null, 0

      it 'should generate 2 mocha suite', ->
        suites = runner.mocha.suite.suites
        assert.equal suites.length, 2
        assert.equal suites[0].title, '/path'
        assert.equal suites[1].title, '/another-path'

      it 'should generate 2 tests in suite 1', ->
        tests = runner.mocha.suite.suites[0].tests
        assert.equal tests.length, 2

      it 'should generate 1 tests in suite 2', ->
        tests = runner.mocha.suite.suites[1].tests
        assert.equal tests.length, 1
