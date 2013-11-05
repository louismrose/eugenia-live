define [
  'paper'
  'viewmodels/drawings/stencils/bounded_stencil'
], (paper, BoundedStencil) ->

  class RoundedRectangleStencil extends BoundedStencil
    createPath: (node) ->
      bounds = new paper.Rectangle(0, 0, @_width(node), @_height(node))
      new paper.Path.RoundRectangle(bounds, new paper.Size(10, 10))