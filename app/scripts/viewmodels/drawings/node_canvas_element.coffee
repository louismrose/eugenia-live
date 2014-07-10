define [
  'viewmodels/drawings/canvas_element'
  'viewmodels/drawings/stencils/stencil_factory'
  'models/commands/delete_node'
  'models/commands/composite_command'
  'models/commands/move_node'
], (CanvasElement, StencilFactory, DeleteNode, CompositeCommand, MoveNode) ->

  class NodeCanvasElement extends CanvasElement
    constructor: (@_element, @_path, @_canvas) ->
      super(@_element, @_path, @_canvas)
      @_element.bind("move", =>
        @_path.setPosition(@_element.position)
        @_canvas.updateDrawingCache()
      )
    
    isNode: =>
      true
 
    moveBy: (point, options={persist: true}) =>
      commands = []
      @_path.move(point)
      commands.push(new MoveNode(@_element, @_element.position, @_path.position()))
      
      for link in @_links()
        commands.push(link.reconnectTo(@_element, point))
   
      @_canvas.run(new CompositeCommand(commands)) if options.persist

    _links: =>
      @_canvas.elementFor(link) for link in @_element.links()   
       
    _destroyCommand: (drawing) =>
      new DeleteNode(drawing, @_element)

