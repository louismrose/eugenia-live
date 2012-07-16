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
    item = @selection()
    if (@isNode(item))
      item.position = event.point # TODO use some other indicator instead

  onMouseUp: (event) ->
    item = @selection()
    if (@isNode(item))
      node = item.model
      node.moveTo(event.point)
      node.save()
    
module.exports = SelectTool