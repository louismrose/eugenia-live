define [
  'spine'
  'models/commands/delete_node'
  'models/commands/composite_command'
  'models/commands/move_node'
], (Spine, DeleteNode, CompositeCommand, MoveNode) ->

  class NodeCanvasElement extends Spine.Module
    @include(Spine.Events)
    
    constructor: (@element, @canvas) ->
      @canvasElement = @element.toPath()
      @linkToThis(@canvasElement)
      @linkToModel(@canvasElement)
            
      @element.bind("move", @updatePosition)
      @element.bind("destroy", @remove)

    linkToThis: (canvasElement) =>
      canvasElement.canvasElement = @
      @linkToThis(c) for c in canvasElement.children if canvasElement.children
    
    linkToModel: (canvasElement) =>
      canvasElement.model = @element
      @linkToModel(c) for c in canvasElement.children if canvasElement.children

    # TODO make "private"
    remove: =>
      @canvasElement.remove()
      @trigger("destroy")

    # TODO make "private"
    updatePosition: =>
      @canvasElement.position = @element.position

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

    links: =>
      @canvas.elementFor(link) for link in @element.links()

    isNode: =>
      true
      
    select: =>
      @canvas.clearSelection()
      @canvasElement.firstChild.selected = true
      @element.select()

