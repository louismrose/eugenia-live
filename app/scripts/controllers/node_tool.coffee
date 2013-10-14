define [
  'controllers/tool'
  'models/commands/create_node'
], (Tool, CreateNode) ->

  class NodeTool extends Tool
    parameters: {'shape' : null}
  
    onMouseDown: (event) =>
      if @parameters.shape
        @parameters.position = { x: event.point.x, y: event.point.y }
        @canvas.add(@run(new CreateNode(@drawing, @parameters)))
        @canvas.clearSelection()
      
    onMouseMove: (event) =>
      if @parameters.shape
        @canvas.clearSelection()
        @canvas.selectAt(event.point)
