define [
  'models/point'
], (Point) ->
  
  class MoveNode
    constructor: (@node, offset) ->
      @offset = new Point(offset.x, offset.y)
  
    run: =>
      @node.moveBy(@offset)
  
    undo: =>
      @node.moveBy(@offset.invert())
    