define [
  'viewmodels/drawings/tools/tool'
], (Tool) ->

  class NodeTool extends Tool
    parameters: {'shape' : null}
  
    onMouseDown: (event) =>
      if @parameters.shape
        @parameters.position = { x: event.point.x, y: event.point.y }
        @canvas.addNode(@parameters)
        @canvas.clearSelection()
      
    onMouseMove: (event) =>
      if @parameters.shape
        @canvas.elementAt(event.point).select()
