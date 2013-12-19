### EllipseStencil
This class is responsible for rendering Nodes whose NodeShape has the `ellipse`
value for its `figure` property.

    define [
      'paper'
      'viewmodels/drawings/stencils/bounded_stencil'
      'viewmodels/drawings/paths/ellipse'
    ], (paper, BoundedStencil, Ellipse) ->

      class EllipseStencil extends BoundedStencil
        draw: (node) ->
          new Ellipse(@_properties(node))