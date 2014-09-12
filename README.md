**ramlev** is a simple RAML Example Validator, which is used to validate the examples defined in RAML against its schema.

[![Build Status](http://img.shields.io/travis/cybertk/raml-example-validator.svg?style=flat)](https://travis-ci.org/cybertk/raml-example-validator)

## Installation

[Node.js][] and [NPM][] is required.

    $ npm install -g ramlev

[Node.js]: https://npmjs.org/
[NPM]: https://npmjs.org/

## Get Started Validating Your RAML Examples

    $ ramlev api.raml

## Command Line Options

    $ ramlev --help
    Usage:
      ramlev <path to raml> [OPTIONS]

    Example:
      ramlev ./api.raml

    Options:
      --reporter, -r       Specify the reporter to use.
                                                                       [default: spec]
      --help               Show usage information.
      --version            Show version number.

## Contribution

Any contribution is more then welcome!
