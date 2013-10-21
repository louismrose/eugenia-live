define [
  'paper'
  'viewmodels/drawings/stencils/polygon_stencil'
], (paper, PolygonStencil) ->

  class BoundedStencil extends PolygonStencil
    defaultStencilSpecification: =>
      super().merge({ size: { width: 100, height: 100 } })
    
    _width: (node) =>
      @resolve(node, 'size.width')
    
    _height: (node) =>
      @resolve(node, 'size.height')