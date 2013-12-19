define [
  'paper'
  'viewmodels/drawings/stencils/rectangle_stencil'
], (paper, RectangleStencil) ->

  describe 'RectangleStencil', ->  
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
        expect(new RectangleStencil().defaultSpecification().get("fillColor")).toBe("white")
        
    describe 'can use stencil specification', ->
      beforeEach ->
        @alwaysResolvesPropertySet =
          resolve: (expression, defaultValue) =>
            expression
      
      it 'sets width according to size.width option', ->
        result = createStencil(@alwaysResolvesPropertySet, size: { width: 50 })
        expect(result.width()).toBe(50)
    
      it 'sets height according to size.height option', ->
        result = createStencil(@alwaysResolvesPropertySet, size: { height: 75 })
        expect(result.height()).toBe(75)
      
      it 'sets fillColor according to fillColor option', ->
        result = createStencil(@alwaysResolvesPropertySet, fillColor: 'red')
        expect(result.fillColor().toCSS()).toEqual("rgb(255,0,0)")
      
      it 'sets strokeColor according to borderColor option', ->
        result = createStencil(@alwaysResolvesPropertySet, borderColor: 'red')
        expect(result.strokeColor().toCSS()).toEqual("rgb(255,0,0)") 

      it 'sets position according to position option', ->
        result = createStencil(@alwaysResolvesPropertySet, x: 4, y: 5)
        expect(result.position().x).toBe(4)
        expect(result.position().y).toBe(5) 
        
      it 'sets position according to position option and position of node', ->
        result = createStencil(@alwaysResolvesPropertySet, { x: 4, y: 5 }, { x: 10, y: 20 })
        expect(result.position().x).toBe(4 + 10)
        expect(result.position().y).toBe(5 + 20)
        
    
    createStencil = (propertySet, stencilSpec = {}, nodePosition =  { x: 0, y: 0 }) ->  
      paper = new paper.PaperScope()
      paper.project = new paper.Project()
      stencil = new RectangleStencil(stencilSpec)
      node = new FakeNode(propertySet, nodePosition)
      result = stencil.draw(node)      

    class FakeNode
      constructor: (@properties, @position) ->
