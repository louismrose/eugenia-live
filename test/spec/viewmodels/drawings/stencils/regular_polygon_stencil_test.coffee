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
      it 'sets sides according to sides option', ->
        result = getProperties(sides: 12)
        expect(result.sides).toBe(12)
    
      it 'sets radius according to radius option', ->
        result = getProperties(radius: 75)
        expect(result.radius).toBe(75)
            
            
    createStencil = (specification = {}) ->
      new RegularPolygonStencil(specification)
      
    getProperties = (stencilSpec = {}, position = {}) ->
      node = new FakeNode(position)
      createStencil(stencilSpec)._properties(node)    

    class FakeNode
      constructor: (@position) ->
        @position.x or= 0
        @position.y or= 0
      
        @properties =
          resolve: (expression, defaultValue) =>
            expression