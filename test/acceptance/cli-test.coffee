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
      # See https://travis-ci.org/cybertk/ramlev/jobs/72294778#L231-L233
      # iojs's behaviour is different from nodejs
      assert.include stderr, 'Error: ENOENT'

  describe 'when called with arguments', ->

    describe "when using additional reporters with -r", ->

      before (done) ->
        cmd = "./bin/ramlev ./test/fixtures/song.raml -r spec"

        execCommand cmd, done

      it 'should print using the new reporter', ->
        assert.include stdout, 'passing'

  describe "Arguments with existing raml", ->

    describe "when executing command with simple RAML", ->

      before (done) ->
        cmd = "./bin/ramlev ./test/fixtures/song.raml -r json"

        execCommand cmd, done

      it 'should exit with status 0', ->
        assert.equal exitStatus, 0

      it 'should print count of tests will run', ->
        assert.equal 3, report.tests.length

      it 'should print correct title for request', ->
        assert.equal report.tests[0].fullTitle, '/songs POST request - application/json'
        assert.equal report.tests[1].fullTitle, '/songs POST request - application/hal+json'

      it 'should print correct title for response', ->
        assert.equal report.tests[2].fullTitle, '/songs/{songId} GET response 200 - application/json'

    describe "when executing command with RAML contains csonschema", ->

      before (done) ->
        cmd = "./bin/ramlev ./test/fixtures/csonschema.raml"

        execCommand cmd, done

      it 'should exit with status 0', ->
        assert.equal exitStatus, 0

      it 'should print count of tests will run', ->
        assert.include stdout, 'passing'

    describe 'when executing command with invalid RAML', ->

      describe 'contains 1 error', ->
        before (done) ->
          cmd = "./bin/ramlev ./test/fixtures/invalid_1.raml -r json"

          execCommand cmd, done

        it 'should exit with status 1', ->
          assert.equal exitStatus, 1

        it 'should report correct test stats', ->
          assert.equal report.stats.tests, 3
          assert.equal report.stats.passes, 1
          assert.equal report.stats.failures, 1
          assert.equal report.stats.pending, 1

        it 'should failed on invalidated example', ->
          assert.equal report.failures[0].fullTitle, '/songs/{songId} PUT response 200 - application/json'

      describe 'contains multiple error', ->
        before (done) ->
          cmd = "./bin/ramlev ./test/fixtures/invalid_2.raml -r json"

          execCommand cmd, done

        it 'should exit with status 1', ->
          assert.equal exitStatus, 1

        it 'should report correct test stats', ->
          assert.equal report.stats.tests, 4
          assert.equal report.stats.passes, 1
          assert.equal report.stats.failures, 3
          assert.equal report.stats.pending, 0

        it 'should failed on invalidated example', ->
          assert.equal report.failures[0].fullTitle, '/songs/{songId} PUT request - application/json'
          assert.equal report.failures[1].fullTitle, '/songs/search GET response 200 - application/json'
          assert.equal report.failures[2].fullTitle, '/songs/authors GET response 200 - application/json'


    describe 'when executing command and RAML has defined mediaType in root section', ->

      before (done) ->
        cmd = "./bin/ramlev ./test/fixtures/media-type.raml -r json"

        execCommand cmd, done

      it 'should validate examples defined in RAML', ->
        assert.equal report.stats.tests, 2
        assert.equal report.stats.passes, 2


    describe 'when executing command and RAML example is encoded in UTF-8', ->

      describe 'and example in embedded in RAML', ->

        before (done) ->
          cmd = "./bin/ramlev ./test/fixtures/utf-8.raml -r json"

          execCommand cmd, done

        it 'should validate examples defined in RAML', ->
          assert.equal report.stats.tests, 1
          assert.equal report.stats.passes, 1

      describe 'and example in included in RAML', ->

        before (done) ->
          cmd = "./bin/ramlev ./test/fixtures/utf-8-include.raml -r json"

          execCommand cmd, done

        it 'should validate examples defined in RAML', ->
          assert.equal report.stats.tests, 1
          assert.equal report.stats.passes, 1

    describe "when provided RAML path is absolute", ->

      before (done) ->
        cmd = "./bin/ramlev #{__dirname}/../fixtures/song.raml -r json"

        execCommand cmd, done

      it 'should exit with status 0', ->
        assert.equal exitStatus, 0

    describe "when executing command with RAML includes other RAMLs", ->

      before (done) ->
        cmd = "./bin/ramlev ./test/fixtures/include_other_raml.raml -r json"

        execCommand cmd, done

      it 'should exit with status 0', ->
        assert.equal exitStatus, 0

    describe "when executing command with --fakeroot and --directory options", ->

      before (done) ->
        cmd = "./bin/ramlev ./test/fixtures/include_local_refs.raml -r json -f http://example.com -d #{__dirname}/../fixtures"

        execCommand cmd, done

      it 'should exit with status 0', ->
        assert.equal exitStatus, 0
