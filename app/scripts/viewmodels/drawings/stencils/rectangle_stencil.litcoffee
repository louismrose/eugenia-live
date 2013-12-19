### RectangleStencil
This class is responsible for rendering Nodes whose NodeShape has the `rectangle`
value for its `figure` property.

    define [
      'paper'
      'viewmodels/drawings/stencils/bounded_stencil'
      'viewmodels/drawings/paper/rectangle'
    ], (paper, BoundedStencil, Rectangle) ->

      class RectangleStencil extends BoundedStencil
        createPath: (node) ->
          new Rectangle(width: @_width(node), height: @_height(node))