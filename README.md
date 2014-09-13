**ramlev** is a simple RAML Example Validator, which is used to validate the examples defined in RAML against its schema.

[![Build Status](http://img.shields.io/travis/cybertk/ramlev.svg?style=flat)](https://travis-ci.org/cybertk/ramlev)
[![Dependency Status](https://david-dm.org/cybertk/ramlev.png)](https://david-dm.org/cybertk/ramlev)
[![Coverage Status](https://coveralls.io/repos/cybertk/ramlev/badge.png?branch=master)](https://coveralls.io/r/cybertk/ramlev?branch=master)

## Features

- Support `-r/--reporters` to switch reporter, ramlev support all reporters of [Mocha][]
- Pretty failed message when example is not validated against schema
- Pretty failed message when example/schema itself is not a validate json
- Proper exit status for CI support

[Mocha]: https://www.npmjs.org/package/mocha

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
      --reporter, -r       Specify the reporter to use. [spec]
      --help               Show usage information.
      --version            Show version number.

## Contribution

Any contribution is more then welcome!
