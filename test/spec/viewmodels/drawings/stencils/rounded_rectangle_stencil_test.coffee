define [
  'paper'
  'viewmodels/drawings/stencils/rounded_rectangle_stencil'
], (paper, RoundedRectangleStencil) ->

  describe 'RoundedRectangleStencil', ->  
    describe 'has sensible defaults', ->
      it 'defaults width to 100', ->
        expect(createStencil().defaultSpecification().get("size.width")).toBe(100)   
      
      it 'defaults height to 100', ->
        expect(createStencil().defaultSpecification().get("size.height")).toBe(100)   
      
      it 'inherits default fillColor from polygon', ->
        expect(createStencil().defaultSpecification().get("fillColor")).toBe("white")
        
    describe 'can use stencil specification', ->
      it 'sets width according to size.width option', ->
        expect(getProperties(size: { width: 50 }).width).toBe(50)
    
      it 'sets height according to size.height option', ->
        expect(getProperties(size: { height: 75 }).height).toBe(75)
        
    
    createStencil = (specification = {}) ->  
      new RoundedRectangleStencil(specification)

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
