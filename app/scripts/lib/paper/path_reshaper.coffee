define [], ->
  
  class PaperPathMover 
    constructor: (path, offset) ->
      @path = path
      @offset = offset
    
    moveStart: =>
      @path.firstSegment.point.x += @offset.x
      @path.firstSegment.point.y += @offset.y
  
    moveEnd: =>
      @path.lastSegment.point.x += @offset.x
      @path.lastSegment.point.y += @offset.y
      
    finalise: =>
      @path.removeSegments(1, @path.segments.size - 2)
      @path.simplify(100)
      # @path.remove()
      @path.segments