options =
  fakeroot:
    alias: "f"
    description: "Used to resolve $ref's using a directory as absolute URI\n"

  directory:
    alias: "d"
    description: "Used with the --fakeroot option for resoving $ref's\n"

  reporter:
    alias: "r"
    description: "Specify the reporter to use\n"
    default: "spec"

  help:
    alias: "h"
    description: "Show usage information.\n"

  version:
    description: "Show version number.\n"

module.exports = options
