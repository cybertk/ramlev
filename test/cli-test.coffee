{assert} = require('chai')
{exec} = require('child_process')


CMD_PREFIX = ''

stderr = ''
stdout = ''
exitStatus = null

execCommand = (cmd, callback) ->
  stderr = ''
  stdout = ''
  exitStatus = null

  cli = exec CMD_PREFIX + cmd, (error, out, err) ->
    stdout = out
    stderr = err

    if error
      exitStatus = error.code

  exitEventName = if process.version.split('.')[1] is '6' then 'exit' else 'close'

  cli.on exitEventName, (code) ->
    exitStatus = code if exitStatus == null and code != undefined
    callback()

describe "Command line interface", () ->

  describe "When raml file not found", (done) ->
    before (done) ->
      cmd = "./bin/ramlev ./test/fixtures/nonexistent_path.raml}"

      execCommand cmd, done

    it 'should exit with status 1', () ->
      assert.equal exitStatus, 1

    it 'should print error message to stderr', () ->
      assert.include stderr, 'Error: ENOENT, open'

  describe "Arguments with validated raml", () ->

    it 'should exit with status 0'
