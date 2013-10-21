define [
  'paper'
  'viewmodels/drawings/stencils/bounded_stencil'
], (paper, BoundedStencil) ->

  class EllipseStencil extends BoundedStencil
    createPath: (node) ->
      new paper.Path.Oval(new paper.Rectangle(0, 0, @_width(node), @_height(node)))