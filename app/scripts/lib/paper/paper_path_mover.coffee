define [], ->
  
  class PaperPathMover 
    constructor: (path, offset) ->
      @path = path
      @offset = offset
    
    moveStart: =>
      @path.firstSegment.point.x += @offset.x
      @path.firstSegment.point.y += @offset.y
      @path.simplify(100)
  
    moveEnd: =>
      @path.lastSegment.point.x += @offset.x
      @path.lastSegment.point.y += @offset.y
      @path.simplify(100)
      