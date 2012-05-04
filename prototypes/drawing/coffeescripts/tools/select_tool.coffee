###
  @depend tool.js
  @depend ../models/node.js
###
class grumble.SelectTool extends grumble.Tool
  parameters: {}
  origin: null
  destination: null
  
  onMouseDown: (event) ->
    hitResult = paper.project.hitTest(event.point)
    @clearSelection()
    if hitResult  
      @select(hitResult.item)
      @origin = hitResult.item.position
  
  onMouseDrag: (event) ->
    item = paper.project.selectedItems[0]
    if (item and item.closed)
      item.position = event.point # TODO use some other indicator instead

  onMouseUp: (event) ->
    item = paper.project.selectedItems[0]
    if (item and item.closed)
      @destination = event.point
      node = grumble.Node.find(item.spine_id)
      node.position = @destination
      @reconnect(link, node) for link in node.links()
      node.save()
      
  reconnect: (link, node) ->
    el = @elementFor(link)

    if link.sourceId is node.id
      offset = el.firstSegment.point.subtract(@origin)
      el.removeSegments(0, link.segments.size - 2)
      el.insert(0, @destination.add(offset))
      
    if link.targetId is node.id
      offset = el.lastSegment.point.subtract(@origin)
      el.removeSegments(1, link.segments.size - 1)
      el.add(@destination.add(offset))
      
    el.simplify(100)
    
    link.updateSegments(el.segments)
    link.save()
    
  elementFor: (link) ->
    matches = (el for el in paper.project.activeLayer.children when el.spine_id is link.id and not el.closed)
    matches[0]