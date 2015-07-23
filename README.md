**ramlev** is a simple RAML Example Validator, which is used to validate the examples defined in RAML against its schema.

[![Build Status](http://img.shields.io/travis/cybertk/ramlev.svg?style=flat)](https://travis-ci.org/cybertk/ramlev)
[![Dependency Status](https://david-dm.org/cybertk/ramlev.svg)](https://david-dm.org/cybertk/ramlev)
[![devDependency Status](https://david-dm.org/cybertk/ramlev/dev-status.svg)](https://david-dm.org/cybertk/ramlev#info=devDependencies)
[![Coverage Status](https://img.shields.io/coveralls/cybertk/ramlev.svg)](https://coveralls.io/r/cybertk/ramlev)

## Features

- Support `-r/--reporters` to switch reporter, ramlev support all reporters of [Mocha][]
- Pretty failed message when example is not validated against schema
- Pretty failed message when example/schema itself is not a validate json
- Proper exit status for CI support

[Mocha]: https://www.npmjs.org/package/mocha

## Installation

[Node.js][] and [NPM][] is required, to install latest stable version.

    npm install -g ramlev

[Node.js]: https://npmjs.org/
[NPM]: https://npmjs.org/

To install the lastest development branch.

    npm install git://github.com/cybertk/ramlev.git#master

## Getting Started Validating Your RAML Examples

    ramlev api.raml

## Command Line Options

    ramlev --help

    Usage:
      ramlev <path to raml> [OPTIONS]

    Example:
      ramlev ./api.raml --fakeroot http://example.com

    Options:
      --fakeroot, -f   Used to resolve $ref's using a directory as absolute URI
      --directory, -d  Used with the --fakeroot option for resoving $ref's
      --reporter, -r   Specify the reporter to use [default: "spec"]
      --help, -h       Show usage information.
      --version        Show version number.

## Contribution

Any contribution is more than welcome!
