###
  @depend tool.js
###
class paper.LinkTool extends grumble.Tool
  parameters: {}
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
        @draftLink.finalise()
        @draftingLayer.commit()
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
    
    commit: ->
      @parent.insertChildren(0, @layer.children)
      
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
      @path.dashArray = [10, 0] # solid
      # TODO trim the draft line, rather than hiding the overlap behind the nodes
