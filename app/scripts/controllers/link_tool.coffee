define [
  'controllers/tool'
], (Tool) ->

  class LinkTool extends Tool
    parameters: {'shape' : null}
    drafting: false
  
    onMouseMove: (event) =>
      if @parameters.shape
        @canvas.clearSelection()
        @canvas.elementAt(event.point).select()
  
    onMouseDown: (event) =>
      if @parameters.shape and @canvas.elementAt(event.point).isNode()
        @drafting = true
        @draftLink = new DraftLink(event.point)

    onMouseDrag: (event) =>
      if @drafting
        @draftLink.extendTo(event.point)
        @canvas.clearSelection()
        @canvas.elementAt(event.point).select() if @canvas.elementAt(event.point).isNode()
  
    onMouseUp: (event) =>
      if @drafting 
        if @canvas.elementAt(event.point).isNode()
          path = @draftLink.finalise()
          @parameters.sourceId = @canvas.elementAt(path.firstSegment.point).element.id
          @parameters.targetId = @canvas.elementAt(path.lastSegment.point).element.id
          @parameters.segments = path.segments
          @canvas.addLink(@parameters)
      
        @draftLink.remove()
        @canvas.clearSelection()
        @drafting = false


    class DraftLink
      constructor: (origin) ->
        @path = new paper.Path([origin])
        @path.layer.insertChild(0, @path) # force to bottom
        @path.strokeColor = 'black'
        @path.dashArray = [10, 4] # dash

      extendTo: (point) ->
        @path.add(point)

      finalise: () ->
        @path.simplify(100)
        @path
    
      remove: ->
        @path.remove()