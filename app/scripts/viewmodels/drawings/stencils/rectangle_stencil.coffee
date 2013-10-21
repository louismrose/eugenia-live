define [
  'paper'
  'viewmodels/drawings/stencils/bounded_stencil'
], (paper, BoundedStencil) ->

  class RectangleStencil extends BoundedStencil
    createPath: (node) ->
      new paper.Path.Rectangle(0, 0, @_width(node), @_height(node))