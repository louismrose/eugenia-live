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
      @_element.bind("move", @updatePosition)
    
    isNode: =>
      true
 
    moveBy: (point, options={persist: true}) =>
      @_path.move(point)
      link.reconnectTo(@_element, point) for link in @_links()
      @_canvas.run(@_moveCommand()) if options.persist

    updatePosition: =>
      @_path.setPosition(@_element.position)
      @_canvas.updateDrawingCache()

    _links: =>
      @_canvas.elementFor(link) for link in @_element.links()   
    
    _moveCommand: =>
      commands = (link._reshapeCommand() for link in @_links())
      commands.push(new MoveNode(@_element, @_element.position, @_path.position()))
      console.log("Built", commands)
      new CompositeCommand(commands)
    
    _destroyCommand: (drawing) =>
      new DeleteNode(drawing, @_element)

