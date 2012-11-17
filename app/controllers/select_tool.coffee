Tool = require('controllers/tool')
Node = require('models/node')

class SelectTool extends Tool
  parameters: {}
  
  onMouseDown: (event) ->
    @clearSelection()
    item = @hitTester.nodeOrLinkAt(event.point)
    @select(item)
    @offset = event.point.subtract(item.position)
      
  onMouseDrag: (event) ->
    for item in @selection() when item instanceof Node
      item.moveTo(event.point.subtract(@offset))
      item.save()
    
module.exports = SelectTool