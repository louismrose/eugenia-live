define [
  'spine'
  'viewmodels/drawings/elements'
  'viewmodels/drawings/label'
  'models/commands/delete_node'
  'models/commands/composite_command'
  'models/commands/move_node'
], (Spine, Elements, Label, DeleteNode, CompositeCommand, MoveNode) ->

  class NodeCanvasElement extends Spine.Module
    @include(Spine.Events)
    
    constructor: (@element, @canvas) ->
      @draw()
      @linkToThis(@canvasElement)
            
      @element.bind("move", @updatePosition)
      @element.bind("destroy", @remove)

    # TODO make "private"
    draw: =>
      elements = new Elements(@element.getShape().elements)
      label = new Label(@element.getShape().label)
      @canvasElement = label.draw(@element, elements.draw(@element))

    # TODO make "private"
    linkToThis: (canvasElement) =>
      canvasElement.canvasElement = @
      @linkToThis(c) for c in canvasElement.children if canvasElement.children
    
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

    # TODO make "private"
    links: =>
      @canvas.elementFor(link) for link in @element.links()

    isNode: =>
      true
      
    select: =>
      @canvas.clearSelection()
      @canvasElement.firstChild.selected = true
      @element.select()

