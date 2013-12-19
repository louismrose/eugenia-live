define [
  'paper'
  'viewmodels/drawings/stencils/regular_polygon_stencil'
], (paper, RegularPolygonStencil) ->

  describe 'RegularPolygonStencil', ->  
    describe 'has sensible defaults', ->
      it 'defaults sides to 3', ->
        expect(createStencil().defaultSpecification().get("sides")).toBe(3)  
      
      it 'defaults radius to 50', ->
        expect(createStencil().defaultSpecification().get("radius")).toBe(50)
      
      it 'inherits default fillColor from polygon', ->
        expect(createStencil().defaultSpecification().get("fillColor")).toBe("white")
        
    describe 'can use stencil specification', ->
      beforeEach ->
        @alwaysResolvesPropertySet =
          resolve: (expression, defaultValue) =>
            expression
      
      it 'sets sides according to sides option', ->
        result = createRegularPolygon(@alwaysResolvesPropertySet, { sides: 12 } )
        expect(result.sides).toBe(12)
    
      it 'sets radius according to radius option', ->
        result = createRegularPolygon(@alwaysResolvesPropertySet, { radius: 75 } )
        expect(result.radius).toBe(75)
            
    createRegularPolygon = (propertySet, stencilSpec = {}) ->
      paper = new paper.PaperScope()
      paper.project = new paper.Project()
      stencil = createStencil(stencilSpec)
      node = new FakeNode(propertySet)
      result = stencil.draw(node)
    
    createStencil = (specification = {}) ->
      new RegularPolygonStencil(specification)

    class FakeNode
      constructor: (@properties) ->
