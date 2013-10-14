define [
  'paper'
  'models/point' # TODO: remove this dependency?
  'models/link'
  'models/node'
  'models/moves_path'
], (paper, Point, Link, Node, MovesPath) ->

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

    isSource: (node) =>
      node.id is @element.sourceId
      
    isTarget: (node) =>
      node.id is @element.targetId

    isNode: =>
      @element instanceof Node
      
    select: =>
      @canvasElement.selected = true

  class NullCanvasElement
    select: =>
      # do nothing
    
    isNode: =>
      false
    
    isLink: =>
      false

  class Canvas
    constructor: (options) ->
      @canvasElement = options.canvas
      @drawing = options.drawing
      @elements = {}
    
      paper.setup(@canvasElement)
      @addAll(Node)
      @addAll(Link)

      @redraw()
      
    addAll: (type) =>
      associationMethod = type.className.toLowerCase() + 's' #e.g. Node -> nodes
      elements = @drawing[associationMethod]().all()         #e.g. @drawing.nodes().all()
      console.log("adding all " + elements.length + " " + type.className + "s")
      @add(element, false) for element in elements
  
    add: (element, redraw = true) =>
      canvasElement = new CanvasElement(element, @)
      @elements[element.id] = canvasElement
      canvasElement
      @redraw() if redraw
  
    elementAt: (point) =>
      hitResult = paper.project.hitTest(point)
      if hitResult and hitResult.item.canvasElement
        hitResult.item.canvasElement 
      else 
        new NullCanvasElement
  
    elementFor: (element) =>
      @elements[element.id]
  
    redraw: =>
      paper.view.draw()
      @drawing.cache = @canvasElement.toDataURL()
      @drawing.save()
      
    clearSelection: =>
      paper.project.deselectAll()
      
    selection: =>
      i.canvasElement for i in paper.project.selectedItems