define [
  'paper'
  'viewmodels/drawings/stencils/stencil_factory'
  'viewmodels/drawings/stencils/composite_stencil'
], (paper, StencilFactory, CompositeStencil) ->

  class Elements
    constructor: (stencilSpecifications, factory = new StencilFactory()) ->
      @_stencils = (factory.stencilFor(spec) for spec in stencilSpecifications)
      
    draw: (node) ->
      new CompositeStencil(@_stencils).draw(node)