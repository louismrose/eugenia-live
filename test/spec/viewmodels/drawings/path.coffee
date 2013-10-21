define [
  'paper'
  'viewmodels/drawings/path'
], (paper, Path) ->

  describe 'Path', ->
    it 'creates a paper path of the specified colour', ->
      paperPath = createPath(color: "blue")
      expect(paperPath.strokeColor.toCSS()).toEqual("rgb(0,0,255)")

    it 'creates a paper path with a simple dash array when the style is dash', ->
      paperPath = createPath(style: "dash")
      expect(paperPath.dashArray).toEqual([4,4])

    it 'creates a paper path with no dash array when the style is solid', ->
      paperPath = createPath(style: "solid")
      expect(paperPath.dashArray).toEqual([])

    it 'creates a paper path of the specified shape', ->
      segments = [
        new paper.Segment(new paper.Point(0,0)),
        new paper.Segment(new paper.Point(10,20))
      ]
      paperPath = createPath({}, segments)
      expect(paperPath.segments).toEqual(segments)


    createPath = (options, segments=[]) ->  
      paper = new paper.PaperScope()
      paper.project = new paper.Project()
      path = new Path(options)
      path.draw(segments: segments)
