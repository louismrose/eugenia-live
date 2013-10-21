define [
], () ->
  
  class StencilSpecification
    constructor: (@_properties = {}) ->
    
    merge: (mergee) =>
      mergee = mergee._properties if mergee instanceof StencilSpecification
      @_merge(@_properties, mergee)
      @
    
    _merge: (target, mergee) =>
      for key, value of mergee
        if value instanceof Object
          target[key] or= {}
          target[key] = @_merge(target[key], value)
        else
          target[key] or= value
      target
  
    get: (keys = "") =>
      @_get(@_properties, keys.split("."))
      
    _get: (object, keys = []) =>
      return undefined if object is undefined
      return object unless keys.length
      
      [key, remainingKeys...] = keys
      @_get(object[key], remainingKeys)