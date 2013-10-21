define [
  'paper'
], (paper) ->

  class Element  
    constructor: (@element = {}) ->
      @_merge(@element, @defaults())
    
    defaults: =>
      x: 0
      y: 0
      fillColor: "white"
      borderColor: "black"
    
    draw: (node) =>
      path = @createPath(node)
      path.position = new paper.Point(node.position).add(@resolve(node, 'x'), @resolve(node, 'y'))
      path.fillColor = @resolve(node, 'fillColor')
      path.strokeColor = @resolve(node, 'borderColor')
      path
      
    resolve: (node, key) =>
      # When an option has a dynamic value, such as ${foo}
      # resolve it using the node's property set
      node.properties.resolve(@_get(@element, key), @_get(@defaults(), key))
    
    # Subclasses must implement this method
    createPath: (node) ->
      throw new Error("Instantiate a subclass of Element, rather than Element directly.")
        
    _merge: (target, mergee) =>
      for key, value of mergee
        if value instanceof Object
          target[key] or= {}
          target[key] = @_merge(target[key], value)
        else
          target[key] or= value
      target
      
    _get: (object, keyString) =>
      @_getKeys(object, keyString.split("."))
      
    _getKeys: (object, keys) =>
      return undefined if object is undefined
      return object unless keys.length
      
      [key, remainingKeys...] = keys
      @_getKeys(object[key], remainingKeys)
      
      
        