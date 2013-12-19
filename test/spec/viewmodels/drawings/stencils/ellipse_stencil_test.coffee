define [
  'paper'
  'viewmodels/drawings/stencils/ellipse_stencil'
], (paper, EllipseStencil) ->

  describe 'EllipseStencil', ->  
    describe 'has sensible defaults', ->
      beforeEach ->
        @alwaysDefaultsPropertySet =
          resolve: (expression, defaultValue) =>
            defaultValue
      
      it 'defaults width to 100', ->
        result = createStencil(@alwaysDefaultsPropertySet)
        expect(result.width()).toBe(100)   
      
      it 'defaults height to 100', ->
        result = createStencil(@alwaysDefaultsPropertySet)
        expect(result.height()).toBe(100)
      
      it 'inherits default fillColor from polygon', ->
        expect(new EllipseStencil().defaultSpecification().get("fillColor")).toBe("white")
        
    describe 'can use stencil specification', ->
      beforeEach ->
        @alwaysResolvesPropertySet =
          resolve: (expression, defaultValue) =>
            expression
      
      it 'sets width according to size.width option', ->
        result = createStencil(@alwaysResolvesPropertySet, { size: { width: 50 } } )
        expect(result.width()).toBe(50)
    
      it 'sets height according to size.height option', ->
        result = createStencil(@alwaysResolvesPropertySet, { size: { height: 75 } } )
        expect(result.height()).toBe(75)
        
    
    createStencil = (propertySet, stencilSpec = {}) ->  
      paper = new paper.PaperScope()
      paper.project = new paper.Project()
      stencil = new EllipseStencil(stencilSpec)
      node = new FakeNode(propertySet)
      result = stencil.draw(node)      

    class FakeNode
      constructor: (@properties) ->
