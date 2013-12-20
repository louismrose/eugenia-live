### EllipseStencil
This class is responsible for rendering Nodes whose NodeShape has the `polygon`
value for its `figure` property.

    define [
      'paper'
      'viewmodels/drawings/stencils/polygon_stencil'
      'viewmodels/drawings/paths/regular_polygon'
    ], (paper, PolygonStencil, RegularPolygon) ->

      class RegularPolygonStencil extends PolygonStencil
      
The `sides` and `radius` properties are used when rendering a RegularPolygon.
We first set some sensible defaults in case the NodeShape omits values for any
of these properties.

        defaultSpecification: =>
          super().merge({ sides: 3, radius: 50 })
    
We draw a node by creating a RegularPolygon with the specified number of `sides` 
and with the specified `radius`.   
    
        draw: (node) ->
          new RegularPolygon(@_properties(node))
          
We update the properties method to return the existing properties plus the
`sides` and `radius` properties.

        _properties: (node) =>
          properties = super(node)
          properties.sides = @_sides(node)
          properties.radius = @_radius(node)
          properties
    
        _sides: (node) ->
          @resolve(node, 'sides')
      
        _radius: (node) ->
          @resolve(node, 'radius')