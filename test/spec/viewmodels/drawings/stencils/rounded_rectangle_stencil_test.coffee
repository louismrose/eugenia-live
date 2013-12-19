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
      beforeEach ->
        @alwaysResolvesPropertySet =
          resolve: (expression, defaultValue) =>
            expression
      
      it 'sets width according to size.width option', ->
        result = createRoundedRectangle(@alwaysResolvesPropertySet, { size: { width: 50 } } )
        expect(result.width()).toBe(50)
    
      it 'sets height according to size.height option', ->
        result = createRoundedRectangle(@alwaysResolvesPropertySet, { size: { height: 75 } } )
        expect(result.height()).toBe(75)
        
    
    createRoundedRectangle = (propertySet, stencilSpec = {}) ->  
      paper = new paper.PaperScope()
      paper.project = new paper.Project()
      stencil = createStencil(stencilSpec)
      node = new FakeNode(propertySet)
      result = stencil.draw(node)      

    createStencil = (specification = {}) ->
      new RoundedRectangleStencil(specification)

    class FakeNode
      constructor: (@properties) ->
