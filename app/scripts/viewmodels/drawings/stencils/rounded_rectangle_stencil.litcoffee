### RoundedRectangleStencil
This class is responsible for rendering Nodes whose NodeShape has the `rounded`
value for its `figure` property, currently by drawing a Paper.js RoundRectangle.

    define [
      'paper'
      'viewmodels/drawings/stencils/bounded_stencil'
    ], (paper, BoundedStencil) ->

      class RoundedRectangleStencil extends BoundedStencil
        createPath: (node) ->
          bounds = new paper.Rectangle(0, 0, @_width(node), @_height(node))
          new paper.Path.RoundRectangle(bounds, new paper.Size(10, 10))