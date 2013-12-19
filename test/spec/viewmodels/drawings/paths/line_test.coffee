define [
  'paper'
  'viewmodels/drawings/paths/line'
], (paper, Line) ->

  describe 'Line', ->
    it 'creates a Paper.js Path', ->
      path = createLine()
      expect(path._paperItem instanceof paper.Path).toBeTruthy()
    
    it 'creates a Paper.js Path of the right color', ->
      path = createLine(color: 'red')
      expect(path._paperItem.strokeColor.toCSS()).toEqual("rgb(255,0,0)")
    
    it 'creates a Paper.js Path of the right style when dashed', ->
      path = createLine(dashed: true)
      expect(path._paperItem.dashArray).toEqual([4, 4])

    it 'creates a Paper.js Path of the right style when not dashed', ->
      path = createLine(dashed: false)
      expect(path._paperItem.dashArray).toEqual([])
    
  
    createLine = (properties = { color: 'black' }, segments = []) ->
      new Line(segments, properties)
    
    # describe 'has sensible defaults', ->
  #     it 'defaults color to black', ->
  #       expect(createStencil().defaultSpecification().get("color")).toBe("black")
  #   
  #     it 'defaults style to solid', ->
  #       expect(createStencil().defaultSpecification().get("style")).toBe("solid")
  #     
  #   describe 'can use stencil specification', ->    
  #     it 'sets color according to color option', ->
  #       expect(createStencil({ color: "blue" })._specification.get("color")).toBe("blue")
  # 
  #     it 'sets style according to style option', ->
  #       expect(createStencil({ style: "dash" })._specification.get("style")).toBe("dash")
  #     
  #   describe 'draw', ->
  #     it 'creates a Line of the specified colour', ->
  #       expect(createPath(color: "blue").strokeColor().toCSS()).toEqual("rgb(0,0,255)")
  # 
  #     it 'creates a paper path with a simple dash array when the style is dash', ->
  #       expect(createPath(style: "dash").dashArray()).toEqual([4,4])
  # 
  #     it 'creates a paper path with no dash array when the style is solid', ->
  #       expect(createPath(style: "solid").dashArray()).toEqual([])
  # 
  #     it 'creates a paper path of the specified shape', ->
  #       segments = [
  #         new paper.Segment(new paper.Point(0,0)),
  #         new paper.Segment(new paper.Point(10,20))
  #       ]
  #       expect(createPath({}, segments).segments()).toEqual(segments)