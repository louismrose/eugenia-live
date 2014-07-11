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
    

    describe 'redraw', ->
      it 'updates the color', ->
        path = createLine()
        path.redraw(color: 'blue')
        expect(path._paperItem.strokeColor.toCSS()).toEqual("rgb(0,0,255)")
      
      it 'updates the style', ->
        path = createLine()
        path.redraw(dashed: true)
        expect(path._paperItem.dashArray).toEqual([4, 4])
      
      it 'can update the style to undashed', ->
        path = createLine(dashed: true)
        path.redraw(dashed: false)
        expect(path._paperItem.dashArray).toEqual([])
  
    createLine = (properties = { color: 'black' }, segments = []) ->
      new Line(segments, properties)