define [
  'paper'
  'models/point' # TODO: remove this dependency?
  'models/node'
  'models/moves_path'
  'models/commands/delete_element'
  'models/commands/composite_command'
  'models/commands/move_node'
  'models/commands/reshape_link'
], (paper, Point, Node, MovesPath, DeleteElement, CompositeCommand, MoveNode, ReshapeLink) ->

  class CanvasElement
    constructor: (@element, @canvas) ->
      @canvasElement = @element.toPath()
      @linkToThis(@canvasElement)
      @linkToModel(@canvasElement)
      
      # TODO trim the line in the tool
      # rather than hiding the overlap behind the nodes here
      paper.project.activeLayer.insertChild(0, @canvasElement)

    linkToThis: (canvasElement) =>
      canvasElement.canvasElement = @
      @linkToThis(c) for c in canvasElement.children if canvasElement.children
    
    linkToModel: (canvasElement) =>
      canvasElement.model = @element
      @linkToModel(c) for c in canvasElement.children if canvasElement.children

    remove: (redraw = true) =>
      @canvasElement.remove()
      @canvas.commander.run(new DeleteElement(@canvas.drawing, @element))
      link.remove(false) for link in @links() if @isNode()
      @canvas.redraw() if redraw
    
    moveBy: (point) =>
      offset = new Point(point.x, point.y)
      @canvasElement.position = offset.add(@canvasElement.position)
      link.reconnectTo(@element, offset) for link in @links()
      @canvas.redraw()

    links: =>
      @canvas.elementFor(link) for link in @element.links()

    reconnectTo: (node, offset) =>
      mover = new MovesPath(@canvasElement.firstChild, offset)
      mover.moveStart() if @isSource(node)
      mover.moveEnd() if @isTarget(node)
      mover.finalise()

    updateModel: =>
      commands = []
      commands.push new MoveNode(@element, @element.position, @canvasElement.position)
      for link in @links()
        commands.push new ReshapeLink(link.element, link.element.segments, link.canvasElement.firstChild.segments)

      @canvas.commander.run(new CompositeCommand(commands))

    isSource: (node) =>
      node.id is @element.sourceId
      
    isTarget: (node) =>
      node.id is @element.targetId

    isNode: =>
      @element instanceof Node
      
    select: =>
      @canvasElement.selected = true

