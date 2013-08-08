define [
  'models/moves_path'
  'paper'
  'jquery'
], (MovesPath, Paper, $) ->

  describe 'MovesPath', ->
    beforeEach ->
      Paper.setup($('canvas')[0])

      @start  = new Paper.Point(10, 20)
      @middle = new Paper.Point(20, 30)
      @end    = new Paper.Point(30, 40)

      @path = new Paper.Path()
      @path.add(@start)
      @path.add(@middle)
      @path.add(@end)
    
      @offset = new Paper.Point(50, 100)
      @mover = new MovesPath(@path, @offset)

      @addMatchers(
        toBeInTheSamePlaceAs: (expected) ->
          @message = -> "Expected (#{expected.x},#{expected.y}) but got (#{@actual.x},#{@actual.y})"
        
          (@actual.x is expected.x) and (@actual.y is expected.y)
      )

    it 'can move the start of a path', ->
      @mover.moveStart()
      expect(@path.firstSegment.point).toBeInTheSamePlaceAs(@start.add(@offset))
    
    it 'can move the end of a path', ->
      @mover.moveEnd()
      expect(@path.lastSegment.point).toBeInTheSamePlaceAs(@end.add(@offset))
    
    it 'can move the start and end of a path without affecting the middle', ->
      @mover.moveStart()
      @mover.moveEnd()
      expect(@path.segments[1].point).toBeInTheSamePlaceAs(@middle)
    
    it 'can remove the middle when finalising', ->
      expect(@mover.finalise().length).toEqual(2)
    