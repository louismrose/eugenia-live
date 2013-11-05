### RectangleStencil
This class is responsible for rendering Nodes whose NodeShape has the `rectangle`
value for its `figure` property, currently by drawing a Paper.js Rectangle.

    define [
      'paper'
      'viewmodels/drawings/stencils/bounded_stencil'
    ], (paper, BoundedStencil) ->

      class RectangleStencil extends BoundedStencil
        createPath: (node) ->
          new paper.Path.Rectangle(0, 0, @_width(node), @_height(node))