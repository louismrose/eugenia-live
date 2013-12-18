define [
  'spine'
  'viewmodels/drawings/stencils/stencil_factory'
  'models/commands/delete_node'
  'models/commands/composite_command'
  'models/commands/move_node'
], (Spine, StencilFactory, DeleteNode, CompositeCommand, MoveNode) ->

  class NodeCanvasElement extends Spine.Module
    @include(Spine.Events)
    
    constructor: (@element, @canvas, stencilFactory = new StencilFactory()) ->
      stencil = stencilFactory.convertNodeShape(@element.getShape())
      @canvasElement = stencil.draw(@element)
      
      @linkToThis(@canvasElement)
      
      @element.bind("destroy", @remove)

    # TODO make "private"
    linkToThis: (paperItem) =>
      paperItem.viewModel = @
      @linkToThis(c) for c in paperItem.children if paperItem.children
    
    # TODO make "private"
    remove: =>
      @canvasElement.remove()

    destroy: =>
      @canvas.commander.run(new DeleteNode(@canvas.drawing, @element))
    
    moveBy: (point, options={persist: true}) =>
      commands = []
      @canvasElement.position = point.add(@canvasElement.position)
      commands.push new MoveNode(@element, @element.position, @canvasElement.position)

      for link in @links()
        commands.push(link.reconnectTo(@element, point))
      
      if options.persist
        @canvas.commander.run(new CompositeCommand(commands))
        @canvas.updateDrawingCache()

    # TODO make "private"
    links: =>
      @canvas.elementFor(link) for link in @element.links()

    isNode: =>
      true
      
    select: =>
      @canvas.clearSelection()
      @canvasElement.firstChild.selected = true
      @element.select()

