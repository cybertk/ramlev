_ = require 'underscore'

module.exports = extractSchemas = (tests) ->
  retval = []

  _.each tests, (test) ->
    test.refaked = retval.push(test.parseSchema()) - 1 unless test.skip()

  retval
