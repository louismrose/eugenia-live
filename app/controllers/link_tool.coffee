Tool = require('controllers/tool')
Link = require('models/link')

class LinkTool extends Tool
  parameters: {'shape' : null}
  drafting: false
  
  onMouseMove: (event) ->
    if @parameters.shape
      @clearSelection()
      @select(@hitTester.nodeAt(event.point))
  
  onMouseDown: (event) ->
    if @parameters.shape and @hitTester.nodeAt(event.point)
      @drafting = true
      @draftLink = new DraftLink(event.point)

  onMouseDrag: (event) ->
    if @drafting
      @draftLink.extendTo(event.point)
      @changeSelectionTo(@hitTester.nodeAt(event.point)) if @hitTester.nodeAt(event.point)
  
  onMouseUp: (event) ->
    if @drafting 
      if @hitTester.nodeAt(event.point)
        path = @draftLink.finalise()
        @parameters.sourceId = @hitTester.nodeAt(path.firstSegment.point).id
        @parameters.targetId = @hitTester.nodeAt(path.lastSegment.point).id
        @parameters.segments = path.segments
        @drawing.links().create(@parameters).save()
      
      @draftLink.remove()
      @clearSelection()
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
     
module.exports = LinkTool