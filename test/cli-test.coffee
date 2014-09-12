{assert} = require('chai')
{exec} = require('child_process')


CMD_PREFIX = ''

stderr = ''
stdout = ''
report = ''
exitStatus = null

execCommand = (cmd, callback) ->
  stderr = ''
  stdout = ''
  report = ''
  exitStatus = null

  cli = exec CMD_PREFIX + cmd, (error, out, err) ->
    stdout = out
    stderr = err
    try
      report = JSON.parse out

    if error
      exitStatus = error.code

  exitEventName = if process.version.split('.')[1] is '6' then 'exit' else 'close'

  cli.on exitEventName, (code) ->
    exitStatus = code if exitStatus == null and code != undefined
    callback()

describe "Command line interface", ->

  describe "When raml file not found", (done) ->
    before (done) ->
      cmd = "./bin/ramlev ./test/fixtures/nonexistent_path.raml"

      execCommand cmd, done

    it 'should exit with status 1', ->
      assert.equal exitStatus, 1

    it 'should print error message to stderr', ->
      assert.include stderr, 'Error: ENOENT, open'

  describe 'when called with arguments', ->

    describe "when using additional reporters with -r", ->

      before (done) ->
        cmd = "./bin/ramlev ./test/fixtures/song.raml -r spec"

        execCommand cmd, done

      it 'should print using the new reporter', ->
        assert.include stdout, 'passing'

    describe "when list reporters with --reporters", ->

      before (done) ->
        cmd = "./bin/ramlev --reporters"

        execCommand cmd, done

      it 'should print all avilable reporters', ->
        assert.include stdout, 'spec - hierarchical spec list'
        assert.include stdout, 'json - single json object'


  describe "Arguments with validated raml", ->

    before (done) ->
      cmd = "./bin/ramlev ./test/fixtures/song.raml -r json"

      execCommand cmd, done

    it 'should exit with status 0', ->
      assert.equal exitStatus, 0

    it 'should print count of tests will run', ->
      assert.equal 8, report.tests.length

    it 'should print correct title for request', ->
      assert.equal report.tests[0].fullTitle, '/songs GET request'
      assert.equal report.tests[4].fullTitle, '/songs/{songId} GET request'

    it 'should print correct title for response', ->
      assert.equal report.tests[1].fullTitle, '/songs GET response'
      assert.equal report.tests[5].fullTitle, '/songs/{songId} GET response 200'

    it 'should skip test when no schema/example section', ->
      assert.equal report.pending[0].fullTitle, '/songs GET request'
      assert.equal report.pending[1].fullTitle, '/songs GET response'

  describe 'Arguments with invalidated raml', ->

    before (done) ->
      cmd = "./bin/ramlev ./test/fixtures/invalid_1.raml -r json"

      execCommand cmd, done

    it 'should exit with status 1', ->
      assert.equal exitStatus, 1

    it 'should test failed on invalidated example', ->
       assert.equal report.failures[0].fullTitle, '/songs/{songId} GET response 200'
