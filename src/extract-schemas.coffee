_ = require 'underscore'

parse = (json) ->
  try
    JSON.parse json
    # throw new Error "#{e} (#{json})"

module.exports = extractSchemas = (schema) ->
  retval = []

  return retval unless schema.resources

  _.each schema.resources, (resource) ->
    return unless resource and resource.methods

    _.each resource.methods, (method) ->
      return unless method and method.responses

      _.each method.responses, (response, status) ->
        return unless response and response.body

        _.each response.body, (body, type) ->
          return if type isnt 'application/json'
          return unless body and body.schema

          if body.schema.indexOf('$schema') isnt -1
            response.body[type].__offset = retval.push(parse body.schema) - 1

    retval = retval.concat(extractSchemas(resource)) if resource.resources

  retval
