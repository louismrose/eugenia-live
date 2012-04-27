###
  @depend tool.js
###
class paper.SelectTool extends grumble.Tool
  parameters: {}
  origin: null
  
  onMouseDown: (event) ->
    hitResult = paper.project.hitTest(event.point)    
    paper.project.activeLayer.selected = false
    if hitResult  
      hitResult.item.selected = true
      @origin = hitResult.item.position
  
  onMouseDrag: (event) ->
    item = paper.project.selectedItems[0]
    if (item and item.closed)
      item.position = event.point

  onMouseUp: (event) ->
    item = paper.project.selectedItems[0]
    if (item and item.links)
      @reconnect(link, item) for link in item.links
      
  reconnect: (link, item) ->
    if link.source is item
      offset = link.firstSegment.point.subtract(@origin)
      link.removeSegment(0)
      link.insert(0, item.position.add(offset))
      
    if link.target is item
      offset = link.lastSegment.point.subtract(@origin)
      link.removeSegment(link.segments.size - 1)
      link.add(item.position.add(offset))
      
    link.simplify(100)