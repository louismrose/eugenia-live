define [
  'controllers/tool'
  'models/commands/create_node'
], (Tool, CreateNode) ->

  class NodeTool extends Tool
    parameters: {'shape' : null}
  
    onMouseDown: (event) =>
      if @parameters.shape
        @parameters.position = { x: event.point.x, y: event.point.y }
        @run(new CreateNode(@drawing, @parameters))
        @clearSelection()
      
    onMouseMove: (event) =>
      if @parameters.shape
        @clearSelection()
        @select(@hitTester.nodeAt(event.point))
