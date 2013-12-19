### RoundedRectangleStencil
This class is responsible for rendering Nodes whose NodeShape has the `rounded`
value for its `figure` property.

    define [
      'paper'
      'viewmodels/drawings/stencils/bounded_stencil'
      'viewmodels/drawings/paths/rounded_rectangle'
    ], (paper, BoundedStencil, RoundedRectangle) ->

      class RoundedRectangleStencil extends BoundedStencil
        draw: (node) ->
          new RoundedRectangle(@_properties(node))