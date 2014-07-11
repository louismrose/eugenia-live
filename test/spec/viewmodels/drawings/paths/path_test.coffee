define [
  'paper'
  'viewmodels/drawings/paths/rectangle'
], (paper, Rectangle) ->

  describe 'Path', ->
    beforeEach ->
      @fillColor = "#ff0000"
      @strokeColor = "#0000ff"
      @position = { x: 50, y: 50 }
      @path = new Rectangle(fillColor: @fillColor, strokeColor: @strokeColor, position: @position, width: 50, height: 50)
    
    it 'should set the fill colour', ->
      expect(@path._paperItem.fillColor.toCSS()).toBe("rgb(255,0,0)")
    
    it 'should set the stroke colour', ->
      expect(@path._paperItem.strokeColor.toCSS()).toBe("rgb(0,0,255)")
  
    it 'should set the position', ->
      expect(@path._paperItem.position.x).toBe(@position.x)
      expect(@path._paperItem.position.y).toBe(@position.y)

    
    describe 'redraw', ->
      beforeEach ->
        @newFillColor = "#800000"
        @newStrokeColor = "#000080"
        @newPosition = { x: 100, y: 100 }
        @path.redraw(fillColor: @newFillColor, strokeColor: @newStrokeColor, position: @newPosition, width: 50, height: 50)
      
      it 'updates the fill colour', ->
        expect(@path._paperItem.fillColor.toCSS()).toBe("rgb(128,0,0)")
      
      it 'updates the stroke colour', ->
        expect(@path._paperItem.strokeColor.toCSS()).toBe("rgb(0,0,128)")
    
      it 'updates the position', ->
        expect(@path._paperItem.position.x).toBe(@newPosition.x)
        expect(@path._paperItem.position.y).toBe(@newPosition.y)
      