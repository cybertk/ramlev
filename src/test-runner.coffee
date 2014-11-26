Mocha = require 'mocha'
async = require 'async'
_ = require 'underscore'


class TestRunner
  constructor: (options = {}) ->
    @options = options
    @mocha = new Mocha options
    @suites = {}

  getOrCreateSuite: (name) =>
    # Generate Test Suite
    @suites[name] ?= Mocha.Suite.create @mocha.suite, name

  addTestToMocha: (test) =>
    mocha = @mocha

    suite = @getOrCreateSuite(test.path)

    if test.skip()
      suite.addTest new Mocha.Test test.name()
      return

    # Setup test
    suite.addTest new Mocha.Test test.name(), (done) ->
      test.run()
      done()

  run: (tests, callback) ->
    addTestToMocha = @addTestToMocha
    mocha = @mocha

    async.each tests, (test, done) ->
      addTestToMocha test
      done()
    , ->
      mocha.run (failures) ->
        callback(null, failures)


module.exports = TestRunner
