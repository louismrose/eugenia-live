Tool = require('controllers/tool')
Link = require('models/link')

class LinkTool extends Tool
  parameters: {'shape' : null}
  drafting: false
  
  onMouseMove: (event) ->
    if @parameters.shape
      hitResult = paper.project.hitTest(event.point)
      @clearSelection()
      @select(hitResult.item) if hitResult and @isNode(hitResult.item)
  
  onMouseDown: (event) ->
    if @parameters.shape
      hitResult = paper.project.hitTest(event.point)
      if hitResult
        @drafting = true
        @draftLink = new DraftLink(event.point)

  onMouseDrag: (event) ->
    if @drafting
      @draftLink.extendTo(event.point)
      hitResult = paper.project.hitTest(event.point)
      if hitResult and @isNode(hitResult.item)
        @changeSelectionTo(hitResult.item)
  
  onMouseUp: (event) ->
    if @drafting 
      hitResult = paper.project.hitTest(event.point)
      if hitResult and @isNode(hitResult.item)
        @drawing.links().create(@draftLink.finalise(@parameters)).save()
      
      @draftLink.remove()
      @clearSelection()
      @drafting = false


  class DraftLink
    constructor: (origin) ->
      @path = new paper.Path([origin])
      @path.layer.insertChild(0, @path) # force to bottom
      @path.strokeColor = 'black'
      @path.dashArray = [10, 4] # dashed

    extendTo: (point) ->
      @path.add(point)

    finalise: (parameters) ->
      @path.simplify(100)
      parameters.sourceId = paper.project.hitTest(@path.firstSegment.point).item.model.id
      parameters.targetId = paper.project.hitTest(@path.lastSegment.point).item.model.id
      parameters.segments = @path.segments
      parameters
    
    remove: ->
      @path.remove()
      
module.exports = LinkTool