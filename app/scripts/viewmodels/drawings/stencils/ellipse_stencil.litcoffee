### EllipseStencil
This class is responsible for rendering Nodes whose NodeShape has the `ellipse`
value for its `figure` property, currently by drawing a Paper.js Oval.

    define [
      'paper'
      'viewmodels/drawings/stencils/bounded_stencil'
    ], (paper, BoundedStencil) ->

      class EllipseStencil extends BoundedStencil
        createPath: (node) ->
          new paper.Path.Oval(new paper.Rectangle(0, 0, @_width(node), @_height(node)))