define [
  'paper'
  'viewmodels/drawings/stencils/stencil_factory'
  'viewmodels/drawings/stencils/rectangle_stencil'
  'viewmodels/drawings/stencils/rounded_rectangle_stencil'
  'viewmodels/drawings/stencils/ellipse_stencil'
  'viewmodels/drawings/stencils/regular_polygon_stencil'
], (paper, StencilFactory, RectangleStencil, RoundedRectangleStencil, EllipseStencil, RegularPolygonStencil) ->

  describe 'StencilFactory', ->  
    it 'creates a rectangle stencil', ->
      result = stencilFor(figure: "rectangle")
      expect(result instanceof RectangleStencil).toBeTruthy()
    
    it 'creates a rounded rectangle stencil', ->
      result = stencilFor(figure: "rounded")
      expect(result instanceof RoundedRectangleStencil).toBeTruthy()

    it 'creates an ellipse stencil', ->
      result = stencilFor(figure: "ellipse")
      expect(result instanceof EllipseStencil).toBeTruthy()

    it 'creates a regular polygon stencil', ->
      result = stencilFor(figure: "polygon")
      expect(result instanceof RegularPolygonStencil).toBeTruthy()
    
    it 'throws an error for unknown type of stencil', ->
      expect(=> stencilFor(figure: "cube")).toThrow()
    
    stencilFor = (stencilSpecification) ->  
      factory = new StencilFactory()
      factory.stencilFor(stencilSpecification)
