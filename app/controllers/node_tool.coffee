Tool = require('controllers/tool')
Node = require('models/node')

class NodeTool extends Tool
  parameters: {'shape' : null}
  
  onMouseDown: (event) ->
    if @parameters.shape
      @parameters.position = event.point
      @node = @drawing.nodes().create(@parameters)
      @node.save()
      @clearSelection()
      
  onMouseMove: (event) ->
    if @parameters.shape
      @clearSelection()
      @select(@hitTester.nodeAt(event.point))
  
  setParameter: (parameterKey, parameterValue) ->
    super(parameterKey, parameterValue)
  
module.exports = NodeTool