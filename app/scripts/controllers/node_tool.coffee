define [
  'controllers/tool'
  'models/commands/create_node'
], (Tool, CreateNode) ->

  class NodeTool extends Tool
    parameters: {'shape' : null}
    timer: 0
  
    onMouseDown: (event) =>
      if @parameters.shape
        @parameters.position = event.point
        @run(new CreateNode(@drawing, @parameters))
        @clearSelection()
      
    onMouseMove: (event) =>
      # if @parameters.shape
      #   @clearSelection()
      #   @select(@hitTester.nodeAt(event.point))
