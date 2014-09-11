options =
  reporter:
    alias: "r"
    description: "Output additional report format. This option can be used multiple times to add multiple reporters. Options: junit, nyan, dot, markdown, html, apiary.\n"
    default: []

  output:
    alias: "o"
    description: "Specifies output file when using additional file-based reporter. This option can be used multiple times if multiple file-based reporters are used.\n"
    default: []

  help:
    description: "Show usage information.\n"

  version:
    description: "Show version number.\n"

module.exports = options
