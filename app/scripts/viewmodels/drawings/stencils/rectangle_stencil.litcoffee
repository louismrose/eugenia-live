### RectangleStencil
This class is responsible for rendering Nodes whose NodeShape has the `rectangle`
value for its `figure` property.

    define [
      'paper'
      'viewmodels/drawings/stencils/bounded_stencil'
      'viewmodels/drawings/paths/rectangle'
    ], (paper, BoundedStencil, Rectangle) ->

      class RectangleStencil extends BoundedStencil
        draw: (node) ->
          new Rectangle(@_properties(node))