define [
  'paper'
  'viewmodels/drawings/stencils/polygon_stencil'
], (paper, PolygonStencil) ->

  describe 'PolygonStencil', ->  
    describe 'has sensible defaults', ->
      it 'defaults x to 0', ->
        expect(createPolygonStencil().defaultSpecification().get("x")).toBe(0)
      
      it 'defaults y to 0', ->
        expect(createPolygonStencil().defaultSpecification().get("y")).toBe(0)

      it 'defaults fillColor to white', ->
        expect(createPolygonStencil().defaultSpecification().get("fillColor")).toBe('white')
    
      it 'defaults borderColor to black', ->
        expect(createPolygonStencil().defaultSpecification().get("borderColor")).toBe("black")
        
        
    describe 'can use stencil specification', ->
      it 'sets position.x according to x option', ->
        expect(getProperties(x: 5).position.x).toBe(5)
    
      it 'sets position.y according to y option', ->
        expect(getProperties(y: 10).position.y).toBe(10)
    
      it 'sets fillColor according to fillColor option', ->
        expect(getProperties(fillColor: 'red').fillColor).toBe('red')

      it 'sets strokeColor according to borderColor option', ->
        expect(getProperties(borderColor: 'blue').strokeColor).toBe('blue')

    describe 'position respects both stencil specification and node position', ->    
      it 'positions according to x option and x position of node', ->
        properties = getProperties({ x: 5 }, { x : 1 })
        expect(properties.position.x).toBe(5 + 1)
    
      it 'positions according to y option and y position of node', ->
        properties = getProperties({ y: 10 }, { y : 3 })
        expect(properties.position.y).toBe(10 + 3)
        
    
    createPolygonStencil = (stencilSpec = {}) ->
      new PolygonStencil(stencilSpec)
    
    getProperties = (stencilSpec = {}, position = {}) ->
      node = new FakeNode(position)
      createPolygonStencil(stencilSpec)._properties(node)    

    class FakeNode
      constructor: (@position) ->
        @position.x or= 0
        @position.y or= 0
      
        @properties =
          resolve: (expression, defaultValue) =>
            expression