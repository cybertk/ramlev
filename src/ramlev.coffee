fs = require 'fs'
spawn = require('child_process').spawn


options = require './options'

class Ramlev
  constructor: (config) ->
    @tests = []
    @stats =
        tests: 0
        failures: 0
        errors: 0
        passes: 0
        skipped: 0
        start: 0
        end: 0
        duration: 0
    @configuration = config
  run: (callback) ->
    config = @configuration
    stats = @stats

    fs.readFile config.ramlPath, 'utf8', (loadingError, data) ->
      return callback(loadingError, stats) if loadingError

      proc = spawn('node_modules/mocha/bin/mocha', [], { customFds: [0,1,2] })
      proc.on 'exit', (code, signal) ->
        process.on 'exit', () ->
          if signal
            process.kill(process.pid, signal)
          else
            process.exit(code);

module.exports = Ramlev
module.exports.options = options
