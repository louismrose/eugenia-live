Tool = require('controllers/tool')
Node = require('models/node')

class SelectTool extends Tool
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
      node = Node.find(item.spine_id)
      node.moveTo(@destination)
      node.save()
    
module.exports = SelectTool