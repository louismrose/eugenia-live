define [
  'spine'
  'paper'
  'models/point' # TODO: remove this dependency?
  'models/node'
  'lib/paper/path_reshaper'
  'models/commands/delete_element'
  'models/commands/composite_command'
  'models/commands/move_node'
  'models/commands/reshape_link'
], (Spine, paper, Point, Node, PathReshaper, DeleteElement, CompositeCommand, MoveNode, ReshapeLink) ->

  class CanvasElement extends Spine.Module
    @include(Spine.Events)
    
    constructor: (@element, @canvas) ->
      @canvasElement = @element.toPath()
      @linkToThis(@canvasElement)
      @linkToModel(@canvasElement)
      
      # TODO trim the line in the tool
      # rather than hiding the overlap behind the nodes here
      paper.project.activeLayer.insertChild(0, @canvasElement)
      
      @element.bind("move", @updatePosition)
      @element.bind("reshape", @updateSegments)
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

    # TODO make "private"
    updateSegments: =>
      @canvasElement.remove()
      @canvasElement = @element.toPath()
      @linkToThis(@canvasElement)
      @linkToModel(@canvasElement)
      
      # TODO trim the line in the tool
      # rather than hiding the overlap behind the nodes here
      paper.project.activeLayer.insertChild(0, @canvasElement)

    destroy: =>
      @canvas.commander.run(new DeleteElement(@canvas.drawing, @element))
    
    moveBy: (point, options={persist: true}) =>
      @canvasElement.position = point.add(@canvasElement.position)
      link.reconnectTo(@element, point) for link in @links()
      
      if options.persist
        commands = []
        commands.push new MoveNode(@element, @element.position, @canvasElement.position)
        for link in @links()
          commands.push new ReshapeLink(link.element, link.element.segments, link.canvasElement.firstChild.segments)
        @canvas.commander.run(new CompositeCommand(commands))
        @canvas.updateDrawingCache()

    links: =>
      @canvas.elementFor(link) for link in @element.links()

    reconnectTo: (node, offset) =>
      mover = new PathReshaper(@canvasElement.firstChild, offset)
      mover.moveStart() if @isSource(node)
      mover.moveEnd() if @isTarget(node)
      mover.finalise()

    isSource: (node) =>
      node.id is @element.sourceId
      
    isTarget: (node) =>
      node.id is @element.targetId

    isNode: =>
      @element instanceof Node
      
    select: =>
      @canvas.clearSelection()
      if @isNode()
        @canvasElement.firstChild.selected = true
      else
        @canvasElement.selected = true
      @element.select()

