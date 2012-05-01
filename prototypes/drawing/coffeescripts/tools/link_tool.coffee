###
  @depend tool.js
###
class paper.LinkTool extends grumble.Tool
  parameters: {'strokeColor' : 'black', 'strokeStyle' : 'solid'}
  draftLink: null
  draftingLayer: null
  drafting: false
  
  onMouseMove: (event) ->
    hitResult = paper.project.hitTest(event.point)
    paper.project.activeLayer.selected = false
    hitResult.item.selected = true if hitResult and hitResult.item.closed
  
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
        paper.project.layers[0].selected = false
        hitResult.item.selected = true
  
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
        attributes.segments = for s in link.segments
          point: {x: s.point.x, y: s.point.y}
          handleIn: {x: s.handleIn.x, y: s.handleIn.y}
          handleOut: {x: s.handleOut.x, y: s.handleOut.y}
        
        console.log("creating link")
        l = new grumble.Link(attributes)
        console.log("created: " + l)
        l.save()
        console.log("saved")
      
      @draftingLayer.dispose()
      paper.project.activeLayer.selected = false
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