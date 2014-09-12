options =
  reporter:
    alias: "r"
    description: "Output additional report format. This option can be used multiple times to add multiple reporters. Options: junit, nyan, dot, markdown, html, apiary.\n"
    default: []

  reporters:
    description: "Display available reporters\n"

  help:
    description: "Show usage information.\n"

  version:
    description: "Show version number.\n"

module.exports = options
