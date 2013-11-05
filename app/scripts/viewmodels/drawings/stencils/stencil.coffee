define [
  'viewmodels/drawings/stencils/stencil_specification'
], (StencilSpecification) ->
  
  class Stencil
    constructor: (stencilSpecification = {}) ->
      @_specification = new StencilSpecification(stencilSpecification)
      @_specification.merge(@defaultSpecification())

    # Subclasses must implement this method    
    defaultSpecification: =>
      throw new Error("Instantiate a subclass rather than this class directly.")
    
    resolve: (element, key) =>
      # When an option has a dynamic value, such as ${foo}
      # resolve it using the element's property set
      element.properties.resolve(@_specification.get(key), @defaultSpecification().get(key))