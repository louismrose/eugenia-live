define [
  'paper'
  'viewmodels/drawings/canvas_element_factory'
  'viewmodels/drawings/null_canvas_element'
  'models/link'
  'models/node'
  'models/commands/create_node'
  'models/commands/create_link'
], (paper, CanvasElementFactory, NullCanvasElement, Link, Node, CreateNode, CreateLink) ->

  class Canvas
    constructor: (options) ->
      @canvasElement = options.el
      @canvasElementFactory = options.factory || new CanvasElementFactory(@)
      @drawing = options.drawing
      @commander = options.commander
      @elements = {}
    
      paper.setup(@canvasElement)
      @_drawAll(Node)
      @_drawAll(Link)

      paper.view.draw()
      @updateDrawingCache()
      
      Node.bind("create", @_draw)
      Link.bind("create", @_draw)
      
    destruct: ->
      Node.unbind("create")
      Link.unbind("create")
      
    _drawAll: (type) =>
      associationMethod = type.className.toLowerCase() + 's' #e.g. Node -> nodes
      elements = @drawing[associationMethod]().all()         #e.g. @drawing.nodes().all()
      console.log("adding all " + elements.length + " " + type.className + "s")
      @_draw(element, persist: false) for element in elements
  
    _draw: (element, options={persist: true}) =>
      canvasElement = @canvasElementFactory.createCanvasElementFor(element)
      
      @elements[@_id_for(element)] = canvasElement
      canvasElement.bind("destroy", => 
        delete @elements[@_id_for(element)]
        @updateDrawingCache()
      )
      @updateDrawingCache() if options.persist
      canvasElement
  
    _id_for: (element) =>
      if element instanceof Node
        "node-#{element.id}"
      else
        "link-#{element.id}"
  
    addNode: (parameters) =>
      node = @commander.run(new CreateNode(@drawing, parameters))
      @_draw(node)
      
    addLink: (parameters) =>
      link = @commander.run(new CreateLink(@drawing, parameters))
      @_draw(link)
        
    elementAt: (point) =>
      hitResult = paper.project.hitTest(point)
      if hitResult and hitResult.item.canvasElement
        hitResult.item.canvasElement 
      else 
        new NullCanvasElement(@)
  
    elementFor: (element) =>
      @elements[@_id_for(element)]
  
    updateDrawingCache: =>
      @drawing.cache = @canvasElement.toDataURL()
      @drawing.save()
      
    clearSelection: =>
      paper.project.deselectAll()
      @drawing.clearSelection()
      
    selection: =>
      if @drawing.getSelection()
        [@elementFor(@drawing.getSelection())]
      else
        []
      
    undo: =>
      @commander.undo()