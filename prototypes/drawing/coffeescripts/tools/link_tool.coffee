###
  @depend tool.js
###
class grumble.LinkTool extends grumble.Tool
  parameters: {'strokeColor' : 'black', 'strokeStyle' : 'solid'}
  draftLink: null
  draftingLayer: null
  drafting: false
  
  onMouseMove: (event) ->
    hitResult = paper.project.hitTest(event.point)
    @clearSelection()
    @select(hitResult.item) if hitResult and hitResult.item.closed
  
  onMouseDown: (event) ->
    hitResult = paper.project.activeLayer.hitTest(event.point)
    if hitResult
      @drafting = true
      @draftingLayer = new DraftingLayer(paper.project.activeLayer)
      @draftLink = new DraftLink(event.point)

  onMouseDrag: (event) ->
    if @drafting
      @draftLink.extendTo(event.point)
      hitResult = @draftingLayer.hitTest(event.point)
      if hitResult and hitResult.item.closed
        @changeSelectionTo(hitResult.item)
        
  
  onMouseUp: (event) ->
    if @drafting 
      hitResult = @draftingLayer.hitTest(event.point)
      if hitResult and hitResult.item.closed 
        attributes = @parameters

        link = @draftLink.finalise()
        attributes.sourceId = @draftingLayer.hitTest(link.firstSegment.point).item.spine_id
        attributes.targetId = @draftingLayer.hitTest(link.lastSegment.point).item.spine_id
          
        @draftingLayer.dispose()
                
        
        # extract the information needed to reconstruct
        # this path (and nothing more)
        attributes.segments = @filterPath(link)
        
        l = new grumble.Link(attributes)
        l.save()
      
      @draftingLayer.dispose()
      @clearSelection()
      @drafting = false


  class DraftingLayer
    parent: null
    layer: null
    
    constructor: (parent) ->
      @parent = parent
      @layer = new paper.Layer()
    
    hitTest: (point) ->
      @parent.hitTest(point)
      
    dispose: ->
      @layer.remove()
      @parent.activate()
      

  class DraftLink
    path: null

    constructor: (origin) ->
      @path = new paper.Path([origin])
      @path.strokeColor = 'black'
      @path.dashArray = [10, 4] # dashed

    extendTo: (point) ->
      @path.add(point)

    finalise: ->
      @path.simplify(100)
      @path