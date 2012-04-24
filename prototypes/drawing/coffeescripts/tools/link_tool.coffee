###
  @depend tool.js
###
class paper.LinkTool extends grumble.Tool
  parameters: {}
  currentLink: null
  linkLayer: null
  
  onMouseMove: (event) ->
    hitResult = paper.project.hitTest(event.point)    
    paper.project.activeLayer.selected = false
    hitResult.item.selected = true if hitResult
  
  onMouseDrag: (event) ->
    unless @currentLink
      @linkLayer = new paper.Layer();
      @currentLink = new paper.Path([event.point])
      @currentLink.strokeColor = 'black'
    @currentLink.add(event.point)
    
    hitResult = paper.project.layers[0].hitTest(event.point)
    if (hitResult)
      paper.project.layers[0].selected = false
      hitResult.item.selected = true
  
  onMouseUp: (event) ->
    if @currentLink
      @currentLink.simplify()
      # TODO: don't draw currentLink, but instead draw a straight line between the source and target nodes
      # TODO: moving a node should extend the line
      paper.project.layers[0].activate()
      hitResult = paper.project.activeLayer.hitTest(event.point)
      paper.project.activeLayer.insertChild(0, @currentLink) if (hitResult)
      paper.project.activeLayer.selected = false
      @linkLayer.remove()
      @currentLink = null
      @linkLayer = null
