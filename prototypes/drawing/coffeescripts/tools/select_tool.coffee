###
  @depend tool.js
###
class paper.SelectTool extends grumble.Tool
  parameters: {}
  
  onMouseDown: (event) ->
    hitResult = paper.project.hitTest(event.point)    
    paper.project.activeLayer.selected = false
    hitResult.item.selected = true if hitResult
  
  onMouseDrag: (event) ->
    if (paper.project.selectedItems[0])
      paper.project.selectedItems[0].position = event.point