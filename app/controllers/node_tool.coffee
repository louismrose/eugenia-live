Tool = require('controllers/tool')
Node = require('models/node')

class NodeTool extends Tool
  parameters: {'shape' : null}
  
  onMouseDown: (event) ->
    if @parameters.shape
      @parameters.position = event.point
      @drawing.nodes().create(@parameters).save()
      @clearSelection()
    
module.exports = NodeTool