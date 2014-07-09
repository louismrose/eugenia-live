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
      @_drawExisting(element) for element in elements
  
    _drawExisting: (element) =>
      canvasElement = @canvasElementFactory.createCanvasElementFor(element)
      @elements[@_id_for(element)] = canvasElement
      element.bind("destroy", @_undraw)
      canvasElement
  
    _draw: (element) =>
      @_drawExisting(element)
      @updateDrawingCache()
          
    _undraw: (element) =>
      delete @elements[@_id_for(element)]
      @updateDrawingCache()
  
    _id_for: (element) =>
      "#{element.type}-#{element.id}"
  
    addNode: (parameters) =>
      @run(new CreateNode(@drawing, parameters))
      
    addLink: (parameters) =>
      @run(new CreateLink(@drawing, parameters))
    
    run: (command) =>
      @commander.run(command)
    
    elementAt: (point) =>
      hitResult = paper.project.hitTest(point)
      if hitResult and hitResult.item.viewModel
        hitResult.item.viewModel
      else 
        new NullCanvasElement(@)
  
    elementFor: (element) =>
      @elements[@_id_for(element)]
  
    updateDrawingCache: =>
      paper.view.draw()
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