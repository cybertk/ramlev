_ = require 'underscore'

module.exports = extractSchemas = (schema) ->
  retval = []

  return retval unless schema.resources

  _.each schema.resources, (resource) ->
    return unless resource.methods

    _.each resource.methods, (method) ->
      return unless method.responses

      _.each method.responses, (response, status) ->
        return unless response.body

        _.each response.body, (body, type) ->
          return if type isnt 'application/json'
          return unless body.schema

          retval.push JSON.parse body.schema

    retval = retval.concat(extractSchemas(resource)) if resource.resources

  retval
