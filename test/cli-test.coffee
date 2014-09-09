{assert} = require('chai')
{exec} = require('child_process')

describe "Command line interface", () ->

  describe "Arguments with validated raml", () ->

    it 'should exit with status 0'
