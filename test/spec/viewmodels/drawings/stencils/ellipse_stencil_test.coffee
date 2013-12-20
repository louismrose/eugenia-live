define [
  'paper'
  'viewmodels/drawings/stencils/ellipse_stencil'
], (paper, EllipseStencil) ->

  describe 'EllipseStencil', ->  
    describe 'has sensible defaults', ->
      beforeEach ->
        @defaults = createStencil().defaultSpecification()
      
      it 'default fillColor to white', ->
        expect(@defaults.get("fillColor")).toBe("white")
      
      it 'default borderColor to black', ->
        expect(@defaults.get("borderColor")).toBe("black")
      
      it 'default x to 0', ->
        expect(@defaults.get("x")).toBe(0)
      
      it 'default y to 0', ->
        expect(@defaults.get("y")).toBe(0)
        
      it 'defaults width to 100', ->
        expect(@defaults.get("size.width")).toBe(100)
      
      it 'defaults height to 100', ->
        expect(@defaults.get("size.height")).toBe(100)
        
      
    describe 'translates properties for Ellipse', ->
      it 'sets fillColor according to fillColor option', ->
        expect(getPropertiesFor(fillColor: 'red').fillColor).toBe('red')
    
      it 'sets strokeColor according to borderColor option', ->
        expect(getPropertiesFor(borderColor: 'red').strokeColor).toBe('red')

      it 'sets position.x according to x option', ->
        expect(getPropertiesFor(x: 5).position.x).toBe(5)

      it 'sets position.y according to y option', ->
        expect(getPropertiesFor(y: 5).position.y).toBe(5)

      it 'sets width according to size.width option', ->
        expect(getPropertiesFor(size: { width: 50 }).width).toBe(50)
    
      it 'sets height according to size.height option', ->
        expect(getPropertiesFor(size: { height: 75 }).height).toBe(75)
    

    describe 'respects existing position of element', ->
      it 'sets position.x according to x option and position of element', ->
        expect(getPropertiesFor({ x: 5 }, { x: 10 }).position.x).toBe(5+10)
    
      it 'sets position.y according to y option and position of element', ->
        expect(getPropertiesFor({ y: 7 }, { y: 12 }).position.y).toBe(7+12)
    
    
    describe 'draw', ->  
      beforeEach ->
        @draw = (specification) ->
          createStencil(specification).draw(new FakeNode)
    
      it 'creates an Ellipse', ->
        path = @draw()
        expect(path.constructor.name).toBe('Ellipse')

      it 'passes properties to Ellipse', ->
        specification = { fillColor: 'red', borderColor: 'yellow', x: 5, y: 5, size: { width: 50, height: 75 } } 
        properties = { fillColor: 'red', strokeColor: 'yellow', position: { x: 5, y: 5 }, width: 50, height: 75 }
        
        path = @draw(specification)
        expect(path._properties).toEqual(properties) 

    
    
    createStencil = (specification = {}) ->  
      new EllipseStencil(specification)

    getPropertiesFor = (stencilSpec = {}, position = {}) ->
      node = new FakeNode(position)
      createStencil(stencilSpec)._properties(node)    

    class FakeNode
      constructor: (@position = {}) ->
        @position.x or= 0
        @position.y or= 0
      
      properties:
        resolve: (expression, defaultValue) =>
          expression
