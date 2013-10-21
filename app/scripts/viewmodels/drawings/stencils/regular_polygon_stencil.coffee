define [
  'paper'
  'viewmodels/drawings/stencils/polygon_stencil'
], (paper, PolygonStencil) ->

  class RegularPolygonStencil extends PolygonStencil
    defaultStencilSpecification: =>
      super().merge({ sides: 3, radius: 50 })
    
    createPath: (node) ->
      centre = new paper.Point(0, 0)
      new paper.Path.RegularPolygon(centre, @_sides(node), @_radius(node))
    
    _sides: (node) ->
      @resolve(node, 'sides')
      
    _radius: (node) ->
      @resolve(node, 'radius')