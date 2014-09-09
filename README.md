# raml-example-validator

[![Build Status](http://img.shields.io/travis/cybertk/raml-example-validator.svg?style=flat)](https://travis-ci.org/cybertk/raml-example-validator)

## Installation

[Node.js][] and [NPM][] is required.

    $ npm install -g raml-example-validator

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
      --reporter, -r       Output additional report format. This option can be used
                           multiple times to add multiple reporters. Options:
                           junit, nyan, dot, markdown, html.
                                                                       [default: []]
      --output, -o         Specifies output file when using additional file-based
                           reporter. This option can be used multiple times if
                           multiple file-based reporters are used.
                                                                       [default: []]
      --inline-errors, -e  Determines whether failures and errors are displayed as
                           they occur (true) or agregated and displayed at the end
                           (false).
                                                                    [default: false]
      --level, -l          The level of logging to output. Options: silly, debug,
                           verbose, info, warn, error.
                                                                   [default: "info"]
      --help               Show usage information.
      --version            Show version number.

Additionally, boolean flags can be negated by prefixing `no-`, for example: `--no-color --no-inline-errors`.

## Contribution

Any contribution is more then welcome!
