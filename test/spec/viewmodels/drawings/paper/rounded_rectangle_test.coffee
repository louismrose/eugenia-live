define [
  'paper'
  'viewmodels/drawings/paper/rounded_rectangle'
], (paper, RoundedRectangle) ->

  describe 'RoundedRectangle', ->
    beforeEach ->
      @width = 10
      @height = 20
      @path = new RoundedRectangle(width: @width, height: @height)
    
    it 'creates a Paper.js Path', ->
      expect(@path._paperItem instanceof paper.Path).toBeTruthy()
    
    it 'creates a Paper.js Path of the right width', ->
      expect(@path._paperItem.bounds.width).toBe(@width)
    
    it 'creates a Paper.js Path of the right height', ->
      expect(@path._paperItem.bounds.height).toBe(@height)