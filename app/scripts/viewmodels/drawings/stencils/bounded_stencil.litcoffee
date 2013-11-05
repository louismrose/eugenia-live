### BoundedStencil
This class is responsible for rendering Nodes whose NodeShape are polygons
with `width` and `height` properties . This class should be subclassed, as it
does not define a complete Stencil on its own.

    define [
      'paper'
      'viewmodels/drawings/stencils/polygon_stencil'
    ], (paper, PolygonStencil) ->

      class BoundedStencil extends PolygonStencil
      
The `width` and `height` properties are used when rendering Paper.js items
with this stencil. We first set some sensible defaults in case the NodeShape
omits values for any of these properties.
      
        defaultSpecification: =>
          super().merge({ size: { width: 100, height: 100 } })

We provide convenience methods for accessing the width and height properties.

        _width: (node) =>
          @resolve(node, 'size.width')
    
        _height: (node) =>
          @resolve(node, 'size.height')