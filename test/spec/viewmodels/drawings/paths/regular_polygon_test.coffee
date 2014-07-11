define [
  'paper'
  'viewmodels/drawings/paths/regular_polygon'
], (paper, RegularPolygon) ->

  describe 'RegularPolygon', ->
    beforeEach ->
      @path = new RegularPolygon(sides: 5, radius: 20)
    
    it 'creates a Paper.js Path', ->
      expect(@path._paperItem instanceof paper.Path).toBeTruthy()
    
    it 'has the correct number of sides', ->
      expect(@path._paperItem.segments.length).toBe(5)
    
    describe 'redraw', ->
      beforeEach ->
        @sides = 7
        @radius = 50
        @path.redraw(sides: @sides, @radius)
      
      it 'updates the number of sides', ->
        expect(@path._paperItem.segments.length).toBe(@sides)
      
      it 'updates the radius', ->
        expect(@path._paperItem.segments.length).toBe(@sides)
        