define [
  'viewmodels/drawings/canvas_element'
  'viewmodels/drawings/stencils/stencil_factory'
  'models/commands/delete_node'
  'models/commands/composite_command'
  'models/commands/move_node'
], (CanvasElement, StencilFactory, DeleteNode, CompositeCommand, MoveNode) ->

  class NodeCanvasElement extends CanvasElement
    isNode: =>
      true
 
    moveBy: (point, options={persist: true}) =>
      commands = []
      @_path.move(point)
      commands.push new MoveNode(@_element, @_element.position, @_path.position())

      for link in @_links()
        commands.push(link.reconnectTo(@_element, point))
   
      if options.persist
        @_canvas.run(new CompositeCommand(commands))
        @_canvas.updateDrawingCache()

    _links: =>
      @_canvas.elementFor(link) for link in @_element.links()   
       
    _destroyCommand: (drawing) =>
      new DeleteNode(drawing, @_element)

