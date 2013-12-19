### RoundedRectangleStencil
This class is responsible for rendering Nodes whose NodeShape has the `rounded`
value for its `figure` property.

    define [
      'paper'
      'viewmodels/drawings/stencils/bounded_stencil'
      'viewmodels/drawings/paper/rounded_rectangle'
    ], (paper, BoundedStencil, RoundedRectangle) ->

      class RoundedRectangleStencil extends BoundedStencil
        createPath: (node) ->
          new RoundedRectangle(width: @_width(node), height: @_height(node))