define [
  'paper'
  'viewmodels/drawings/paths/rectangle'
], (paper, Rectangle) ->

  describe 'Bounded', ->
    beforeEach ->
      @width = 10
      @height = 20
      @position = { x: 50, y: 50 }
      @path = new Rectangle(width: @width, height: @height, position: @position)    
    
    describe 'redraw', ->
      beforeEach ->
        @newWidth = 30
        @newHeight = 40
        @path.redraw(width: @newWidth, height: @newHeight, position: @position)
      
      it 'updates the width', ->
        expect(@path._paperItem.bounds.width).toBe(@newWidth)
        
      it 'updates the height', ->
        expect(@path._paperItem.bounds.height).toBe(@newHeight)
      
      it 'does not change the position when width and height are changed', ->
        expect(@path._paperItem.position.x).toBe(@position.x)
        expect(@path._paperItem.position.y).toBe(@position.y)
        