Point = require('models/point')

class MoveNode
  constructor: (@node, offset) ->
    @offset = new Point(offset.x, offset.y)
  
  run: =>
    @node.moveBy(@offset)
  
  undo: =>
    @node.moveBy(@offset.invert())
    
module.exports = MoveNode

