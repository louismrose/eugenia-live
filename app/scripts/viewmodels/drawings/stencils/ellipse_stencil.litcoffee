### EllipseStencil
This class is responsible for rendering Nodes whose NodeShape has the `ellipse`
value for its `figure` property.

    define [
      'paper'
      'viewmodels/drawings/stencils/bounded_stencil'
      'viewmodels/drawings/paper/ellipse'
    ], (paper, BoundedStencil, Ellipse) ->

      class EllipseStencil extends BoundedStencil
        createPath: (node) ->
          new Ellipse(@_width(node), @_height(node))