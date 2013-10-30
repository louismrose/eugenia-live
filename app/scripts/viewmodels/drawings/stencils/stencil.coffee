define [
  'viewmodels/drawings/stencils/stencil_specification'
], (StencilSpecification) ->
  
  class Stencil
    constructor: (stencilSpecification = {}) ->
      @_stencilSpecification = new StencilSpecification(stencilSpecification)
      @_stencilSpecification.merge(@defaultStencilSpecification())

    # Subclasses must implement this method    
    defaultStencilSpecification: =>
      throw new Error("Instantiate a subclass rather than this class directly.")
    
    resolve: (node, key) =>
      # When an option has a dynamic value, such as ${foo}
      # resolve it using the node's property set
      node.properties.resolve(@_stencilSpecification.get(key), @defaultStencilSpecification().get(key))