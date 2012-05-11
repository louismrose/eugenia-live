Tool = require('controllers/tool')
Node = require('models/node')

class SelectTool extends Tool
  parameters: {}
  
  onMouseDown: (event) ->
    hitResult = paper.project.hitTest(event.point)
    @clearSelection()
    if hitResult  
      @select(hitResult.item)
  
  onMouseDrag: (event) ->
    item = paper.project.selectedItems[0]
    if (item and item.closed)
      item.position = event.point # TODO use some other indicator instead

  onMouseUp: (event) ->
    item = paper.project.selectedItems[0]
    if (item and item.closed)
      node = Node.find(item.spine_id)
      node.moveTo(event.point)
      node.save()
    
module.exports = SelectTool