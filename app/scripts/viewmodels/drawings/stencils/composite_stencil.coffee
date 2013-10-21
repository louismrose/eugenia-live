define [
  'paper'
], (paper) ->

  class CompositeStencil
    constructor: (@stencils = []) ->
    
    draw: (node) =>
      new paper.Group(@_children(node))
    
    _children: (node) =>
      stencil.draw(node) for stencil in @stencils
