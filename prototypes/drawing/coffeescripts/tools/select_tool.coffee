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
    paper.project.activeLayer.selected = false
    if hitResult  
      hitResult.item.selected = true
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

    console.log("Reconnecting " + link + " to " + node)
    console.log("Using " + el)

    if link.sourceId is node.id
      offset = el.firstSegment.point.subtract(@origin)
      el.removeSegment(0)
      el.insert(0, @destination.add(offset))
      
    if link.targetId is node.id
      offset = el.lastSegment.point.subtract(@origin)
      el.removeSegment(link.segments.size - 1)
      el.add(@destination.add(offset))
      
    el.simplify(100)
    
    # FIXME remove duplication with link_tool
    # extract the information needed to reconstruct
    # this path (and nothing more)
    link.segments = for s in el.segments
      point: {x: s.point.x, y: s.point.y}
      handleIn: {x: s.handleIn.x, y: s.handleIn.y}
      handleOut: {x: s.handleOut.x, y: s.handleOut.y}
    link.save()
    
  elementFor: (link) ->
    matches = (el for el in paper.project.activeLayer.children when el.spine_id is link.id and not el.closed)
    matches[0]