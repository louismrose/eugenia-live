Tool = require('controllers/tool')
Node = require('models/node')

class NodeTool extends Tool
  parameters: {'shape' : null}
  
  onMouseDown: (event) ->
    if @parameters.shape
      @parameters.position = event.point
      @drawing.addNode(@parameters)
      @clearSelection()
      
  onMouseMove: (event) ->
    if @parameters.shape
      @clearSelection()
      @select(@hitTester.nodeAt(event.point))
  
module.exports = NodeTool