define [
  'paper'
  'viewmodels/drawings/stencils/regular_polygon_stencil'
], (paper, RegularPolygonStencil) ->

  describe 'RegularPolygonStencil', ->  
    describe 'has sensible defaults', ->
      beforeEach ->
        @alwaysDefaultsPropertySet =
          resolve: (expression, defaultValue) =>
            defaultValue
      
      it 'defaults sides to 3', ->
        result = createStencil(@alwaysDefaultsPropertySet)
        expect(result.segments.length).toBe(3)   
      
      it 'defaults radius to 50', ->
        expect(new RegularPolygonStencil().defaultStencilSpecification()["radius"]).toBe(50)
      
      it 'inherits default fillColor from polygon', ->
        expect(new RegularPolygonStencil().defaultStencilSpecification()["fillColor"]).toBe("white")
        
    describe 'can use stencil specification', ->
      beforeEach ->
        @alwaysResolvesPropertySet =
          resolve: (expression, defaultValue) =>
            expression
      
      it 'sets sides according to sides option', ->
        result = createStencil(@alwaysResolvesPropertySet, { sides: 12 } )
        expect(result.segments.length).toBe(12)
    
      it 'sets radius according to radius option', ->
        polygon = new RegularPolygonStencil(radius: 75)
        expect(polygon._radius(new FakeNode(@alwaysResolvesPropertySet))).toBe(75)
            
    createStencil = (propertySet, stencilSpec = {}) ->
      paper = new paper.PaperScope()
      paper.project = new paper.Project()
      stencil = new RegularPolygonStencil(stencilSpec)
      node = new FakeNode(propertySet)
      result = stencil.draw(node)

    class FakeNode
      constructor: (@properties) ->
