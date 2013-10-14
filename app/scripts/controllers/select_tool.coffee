define [
  'controllers/tool'
  'models/node'
  'models/commands/composite_command'
  'models/commands/move_node'
  'models/commands/reshape_link'
], (Tool, Node, CompositeCommand, MoveNode, ReshapeLink) ->

  class SelectTool extends Tool
    parameters: {}
  
    onMouseDown: (event) =>
      @canvas.clearSelection()
      @canvas.selectAt(event.point)
      @current = event.point
      @start = event.point
      
    onMouseDrag: (event) =>
      for item in @canvas.selection() when item.isNode()
        item.moveBy(event.point.subtract(@current))
        @current = event.point
  
    onMouseUp: (event) =>
      for item in @canvas.selection() when item.isNode()
        item.moveBy(event.point.subtract(@current))

        commands = []
        commands.push new MoveNode(item.element, item.element.position, item.canvasElement.position)
        for link in item.links()
          commands.push new ReshapeLink(link.element, link.element.segments, link.canvasElement.firstChild.segments)

        @commander.run(new CompositeCommand(commands))