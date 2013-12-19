### PolygonStencil
This class is responsible for rendering Nodes whose NodeShape are polygons.
This class should be subclassed, as it does not define a complete Stencil 
on its own.

    define [
      'paper'
      'viewmodels/drawings/stencils/stencil'
      'viewmodels/drawings/stencils/stencil_specification'
    ], (paper, Stencil, StencilSpecification) ->

      class PolygonStencil extends Stencil

The `x`, `y`, `fillColor` and `borderColor` properties are used when rendering
a polygon. We first set some sensible defaults in case the NodeShape omits
values for any of these properties.

        defaultSpecification: =>
          new StencilSpecification(x: 0, y: 0, fillColor: "white", borderColor: "black")
    
We draw a Node by delegating to a method defined in a subclass (`@createPath`)
and then set the position, fill colour and stroke colour of the result Paper.js
Path.

        draw: (node) =>
          path = @createPath(node)
          path.setPosition(new paper.Point(node.position).add(@resolve(node, 'x'), @resolve(node, 'y')))
          path.setFillColor(@resolve(node, 'fillColor'))
          path.setStrokeColor(@resolve(node, 'borderColor'))
          path
      
        # Subclasses must implement this method
        createPath: (node) ->
          throw new Error("Instantiate a subclass rather than this class directly.")