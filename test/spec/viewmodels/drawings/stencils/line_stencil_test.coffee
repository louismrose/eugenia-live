define [
  'paper'
  'viewmodels/drawings/stencils/line_stencil'
], (paper, LineStencil) ->

  describe 'LineStencil', ->      
    describe 'has sensible defaults', ->
      it 'defaults color to black', ->
        expect(createStencil().defaultSpecification().get("color")).toBe("black")
    
      it 'defaults style to solid', ->
        expect(createStencil().defaultSpecification().get("style")).toBe("solid")
      
    describe 'can use stencil specification', ->    
      it 'sets color according to color option', ->
        expect(getProperties(color: "blue").color).toBe("blue")
  
      it 'sets dashed to true if style is dash', ->
        expect(getProperties(style: "dash").dashed).toBeTruthy()
      
      it 'sets dashed to false if style is solid', ->
        expect(getProperties(style: "solid").dashed).toBeFalsy()
      
    describe 'draw', ->
      it 'creates a paper path of the specified shape', ->
        segments = [
          new paper.Segment(new paper.Point(0,0)),
          new paper.Segment(new paper.Point(10,20))
        ]
        
        stencil = createStencil()
        path = stencil.draw(new FakeLink(segments))

        expect(path._paperItem.segments).toEqual(segments)
    
  
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