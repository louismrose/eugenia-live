class paper.LinkTool extends grumble.Tool
  parameters: {}
  currentLink: null
  linkLayer: null
  
  onMouseMove: (event) ->
    hitResult = paper.project.hitTest(event.point)    
    paper.project.activeLayer.selected = false
    hitResult.item.selected = true if hitResult
  
  onMouseDrag: (event) ->
    unless this.currentLink
      this.linkLayer = new paper.Layer();
      this.currentLink = new paper.Path([event.point])
      this.currentLink.strokeColor = 'black'
    this.currentLink.add(event.point)
    
    hitResult = paper.project.layers[0].hitTest(event.point)
    if (hitResult)
      paper.project.layers[0].selected = false
      hitResult.item.selected = true
  
  onMouseUp: (event) ->
    if this.currentLink
      this.currentLink.simplify()
      # TODO: don't draw currentLink, but instead draw a straight line between the source and target nodes
      # TODO: moving a node should extend the line
      paper.project.layers[0].activate()
      hitResult = paper.project.activeLayer.hitTest(event.point)
      paper.project.activeLayer.insertChild(0, this.currentLink) if (hitResult)
      paper.project.activeLayer.selected = false
      this.linkLayer.remove()
      this.currentLink = null
      this.linkLayer = null

