define [
  'paper'
  'viewmodels/drawings/paper/ellipse'
], (paper, Ellipse) ->

  describe 'Ellipse', ->
    beforeEach ->
      @width = 10
      @height = 20
      @path = new Ellipse(width: @width, height: @height)
    
    it 'creates a Paper.js Path', ->
      expect(@path._paperItem instanceof paper.Path).toBeTruthy()
    
    it 'creates a Paper.js Path of the right width', ->
      expect(@path._paperItem.bounds.width).toBe(@width)
    
    it 'creates a Paper.js Path of the right height', ->
      expect(@path._paperItem.bounds.height).toBe(@height)