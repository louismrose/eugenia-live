define [], ->
  
  class JsonNotation
    serialiseNode: (item) ->
      JSON.stringify(item, null, 2)
  
    serialiseLink: (item) ->
      JSON.stringify(item, null, 2)
  
    deserialise: (definition) ->
      JSON.parse(definition)