define [
  'paper'
  'viewmodels/drawings/stencils/line_stencil'
], (paper, LineStencil) ->

  describe 'LineStencil', ->      
    describe 'has sensible defaults', ->
      beforeEach ->
        @defaults = createStencil().defaultSpecification()
      
      it 'defaults color to black', ->
        expect(@defaults.get("color")).toBe("black")
    
      it 'defaults style to solid', ->
        expect(@defaults.get("style")).toBe("solid")
      
      
    describe 'translates properties for Line', ->    
      it 'sets color according to color option', ->
        expect(getProperties(color: "blue").color).toBe("blue")
  
      it 'sets dashed to true if style is dash', ->
        expect(getProperties(style: "dash").dashed).toBeTruthy()
      
      it 'sets dashed to false if style is solid', ->
        expect(getProperties(style: "solid").dashed).toBeFalsy()
      
      
    describe 'draw', ->
      beforeEach ->
        @segments = [
          new paper.Segment(new paper.Point(0,0)),
          new paper.Segment(new paper.Point(10,20))
        ]
        
        @draw = (specification = {}) =>
          createStencil(specification).draw(new FakeLink(@segments))
      
      it 'creates a Line', ->
        path = @draw()
        expect(path.constructor.name).toBe('Line')

      it 'passes to Line the same segments as the link to be drawn', ->
        path = @draw()
        expect(path._paperItem.segments).toEqual(@segments)
        
      it 'passes properties to Line', ->
        specification = { color: 'black', style: 'dash' } 
        properties = { color: 'black', dashed: true }
        
        path = @draw(specification)
        expect(path._properties).toEqual(properties)

    
  
    createStencil = (specification = {}) ->
      new LineStencil(specification)
      
    getProperties = (stencilSpec = {}, segments = []) ->
      link = new FakeLink(segments)
      createStencil(stencilSpec)._properties(link)
      
    class FakeLink
      constructor: (@segments) ->
        @properties =
          resolve: (expression, defaultValue) ->
            expression