Tool = require('controllers/tool')
Node = require('models/node')

class SelectTool extends Tool
  parameters: {}
  
  onMouseDown: (event) ->
    @clearSelection()
    @select(@hitTester.nodeOrLinkAt(event.point))
  
  onMouseDrag: (event) ->
    for item in @selection() when item instanceof Node
      item.moveTo(event.point)
      item.save()
    
module.exports = SelectTool