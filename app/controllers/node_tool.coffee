Tool = require('controllers/tool')
Node = require('models/node')

class NodeTool extends Tool
  parameters: {'shape' : 'rectangle', 'fillColor' : 'white', 'strokeColor' : 'black', 'strokeStyle' : 'solid'}
  
  onMouseDown: (event) ->
    @parameters.position = event.point
    new Node(@parameters).save()
    @clearSelection()
    
module.exports = NodeTool