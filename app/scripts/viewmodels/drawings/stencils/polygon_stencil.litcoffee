### PolygonStencil
This class is responsible for rendering Nodes whose NodeShape are polygons.
This class should be subclassed, as it does not define a complete Stencil 
on its own, as it does not implement the `draw` method.

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
and then set the position, fill colour and stroke colour of the Path.

We then provide a properties method for subclasses to use when instantiating their
chosen Path.
        
        _properties: (node) =>
          {
            position: new paper.Point(node.position).add(@resolve(node, 'x'), @resolve(node, 'y'))
            fillColor: @resolve(node, 'fillColor')
            strokeColor: @resolve(node, 'borderColor')
          }

        draw: (node) =>
          throw new Error("Instantiate a subclass rather than this class directly.")