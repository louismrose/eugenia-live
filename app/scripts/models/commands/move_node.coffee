define [
  'models/point'
], (Point) ->
  
  class MoveNode
    constructor: (@node, source, target) ->
      @source = new Point(source.x, source.y)
      @target = new Point(target.x, target.y)
  
    run: =>
      @node.moveTo(@target)
  
    undo: =>
      @node.moveTo(@source)
    