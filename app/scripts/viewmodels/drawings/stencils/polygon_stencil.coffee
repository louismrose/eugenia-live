define [
  'paper'
  'viewmodels/drawings/stencils/stencil_specification'
], (paper, StencilSpecification) ->

  class PolygonStencil  
    constructor: (stencilSpecification = {}) ->
      @_stencilSpecification = new StencilSpecification(stencilSpecification)
      @_stencilSpecification.merge(@defaultStencilSpecification())
    
    defaultStencilSpecification: =>
      new StencilSpecification(x: 0, y: 0, fillColor: "white", borderColor: "black")
    
    draw: (node) =>
      path = @createPath(node)
      path.position = new paper.Point(node.position).add(@resolve(node, 'x'), @resolve(node, 'y'))
      path.fillColor = @resolve(node, 'fillColor')
      path.strokeColor = @resolve(node, 'borderColor')
      path
      
    resolve: (node, key) =>
      # When an option has a dynamic value, such as ${foo}
      # resolve it using the node's property set
      node.properties.resolve(@_stencilSpecification.get(key), @defaultStencilSpecification().get(key))
          
    # Subclasses must implement this method
    createPath: (node) ->
      throw new Error("Instantiate a subclass rather than this class directly.")