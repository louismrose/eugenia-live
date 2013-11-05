define [
  'paper'
], (paper) ->

  class CompositeStencil
    constructor: (@_stencils = []) ->
    
    draw: (node) =>
      new paper.Group(@_children(node))
    
    _children: (node) =>
      stencil.draw(node) for stencil in @_stencils
