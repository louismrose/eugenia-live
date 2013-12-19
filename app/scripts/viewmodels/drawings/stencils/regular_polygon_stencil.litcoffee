### EllipseStencil
This class is responsible for rendering Nodes whose NodeShape has the `polygon`
value for its `figure` property.

    define [
      'paper'
      'viewmodels/drawings/stencils/polygon_stencil'
      'viewmodels/drawings/paper/regular_polygon'
    ], (paper, PolygonStencil, RegularPolygon) ->

      class RegularPolygonStencil extends PolygonStencil
      
The `sides` and `radius` properties are used when rendering a RegularPolygon.
We first set some sensible defaults in case the NodeShape omits values for any
of these properties.

        defaultSpecification: =>
          super().merge({ sides: 3, radius: 50 })
    
We draw a node by creating a RegularPolygon with the specified number of `sides` 
and with the specified `radius`.   
    
        createPath: (node) ->
          new RegularPolygon(@_sides(node), @_radius(node))
    
        _sides: (node) ->
          @resolve(node, 'sides')
      
        _radius: (node) ->
          @resolve(node, 'radius')