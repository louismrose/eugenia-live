define [
  'viewmodels/drawings/canvas_element'
  'viewmodels/drawings/stencils/stencil_factory'
  'models/commands/delete_node'
  'models/commands/composite_command'
  'models/commands/move_node'
], (CanvasElement, StencilFactory, DeleteNode, CompositeCommand, MoveNode) ->

  class NodeCanvasElement extends CanvasElement
    
    constructor: (element, @_canvas, stencilFactory = new StencilFactory()) ->
      super(element, @_canvas, stencilFactory)

    _stencil: (stencilFactory, shape) =>
      stencilFactory.convertNodeShape(shape)

    _destroyCommand: (drawing) =>
      new DeleteNode(drawing, @_element)
    
    isNode: =>
      true
    
    moveBy: (point, options={persist: true}) =>
      commands = []
      @_canvasElement.position = point.add(@_canvasElement.position)
      commands.push new MoveNode(@_element, @_element.position, @_canvasElement.position)

      for link in @_links()
        commands.push(link.reconnectTo(@_element, point))
      
      if options.persist
        @_canvas.run(new CompositeCommand(commands))
        @_canvas.updateDrawingCache()

    _links: =>
      @_canvas.elementFor(link) for link in @_element.links()

