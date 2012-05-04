###
  @depend tool.js
###
class grumble.LinkTool extends grumble.Tool
  parameters: {'strokeColor' : 'black', 'strokeStyle' : 'solid'}
  draftLink: null
  drafting: false
  
  onMouseMove: (event) ->
    hitResult = paper.project.hitTest(event.point)
    @clearSelection()
    @select(hitResult.item) if hitResult and hitResult.item.closed
  
  onMouseDown: (event) ->
    hitResult = paper.project.hitTest(event.point)
    if hitResult
      @drafting = true
      @draftLink = new DraftLink(event.point)

  onMouseDrag: (event) ->
    if @drafting
      @draftLink.extendTo(event.point)
      hitResult = paper.project.hitTest(event.point)
      if hitResult and hitResult.item.closed
        @changeSelectionTo(hitResult.item)
  
  onMouseUp: (event) ->
    if @drafting 
      hitResult = paper.project.hitTest(event.point)
      if hitResult and hitResult.item.closed
        @draftLink.finalise(@parameters)
      
      @draftLink.remove()
      @clearSelection()
      @drafting = false

  class DraftLink
    path: null

    constructor: (origin) ->
      @path = new paper.Path([origin])
      @path.layer.insertChild(0, @path) # force to bottom
      @path.strokeColor = 'black'
      @path.dashArray = [10, 4] # dashed

    extendTo: (point) ->
      @path.add(point)

    finalise: (parameters) ->
      @path.simplify(100)
      parameters.sourceId = paper.project.hitTest(@path.firstSegment.point).item.spine_id
      parameters.targetId = paper.project.hitTest(@path.lastSegment.point).item.spine_id
      parameters.segments = @path.segments
      new grumble.Link(parameters).save()
    
    remove: ->
      @path.remove()