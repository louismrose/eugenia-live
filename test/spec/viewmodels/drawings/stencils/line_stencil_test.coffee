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
        expect(createStencil({ color: "blue" })._specification.get("color")).toBe("blue")
  
      it 'sets style according to style option', ->
        expect(createStencil({ style: "dash" })._specification.get("style")).toBe("dash")
      
    describe 'draw', ->
      it 'creates a Line of the specified colour', ->
        expect(createPath(color: "blue").strokeColor().toCSS()).toEqual("rgb(0,0,255)")

      it 'creates a paper path with a simple dash array when the style is dash', ->
        expect(createPath(style: "dash").dashArray()).toEqual([4,4])

      it 'creates a paper path with no dash array when the style is solid', ->
        expect(createPath(style: "solid").dashArray()).toEqual([])

      it 'creates a paper path of the specified shape', ->
        segments = [
          new paper.Segment(new paper.Point(0,0)),
          new paper.Segment(new paper.Point(10,20))
        ]
        expect(createPath({}, segments).segments()).toEqual(segments)
    
  
    createPath = (specification, segments=[]) ->  
      paper = new paper.PaperScope()
      paper.project = new paper.Project()
      stencil = createStencil(specification)
      element = new FakeLink(segments)
      stencil.draw(element)

    createStencil = (specification = {}) ->
      new LineStencil(specification)
      
    class FakeLink
      constructor: (@segments) ->
        @properties =
          resolve: (expression, defaultValue) ->
            expression