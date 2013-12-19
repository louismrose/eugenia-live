define [
  'paper'
  'viewmodels/drawings/paper/regular_polygon'
], (paper, RegularPolygon) ->

  describe 'RegularPolygon', ->
    beforeEach ->
      @path = new RegularPolygon(sides: 5, size: 20)
    
    it 'creates a Paper.js Path', ->
      expect(@path._paperItem instanceof paper.Path).toBeTruthy()