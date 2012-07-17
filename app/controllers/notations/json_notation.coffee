class JsonNotation
  serialise: (item) ->
    JSON.stringify(item, null, 2)
    
  deserialise: (definition) ->
    JSON.parse(definition)
    
module.exports = JsonNotation