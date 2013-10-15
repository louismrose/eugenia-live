define [
  'paper'
  'viewmodels/drawings/canvas_element'
  'viewmodels/drawings/null_canvas_element'
  'models/link'
  'models/node'
  'models/commands/create_node'
  'models/commands/create_link'
], (paper, CanvasElement, NullCanvasElement, Link, Node, CreateNode, CreateLink) ->

  class Canvas
    constructor: (options) ->
      @canvasElement = options.el
      @drawing = options.drawing
      @commander = options.commander
      @elements = {}
    
      paper.setup(@canvasElement)
      @drawAll(Node)
      @drawAll(Link)

      paper.view.draw()
      @updateDrawingCache()
      
    drawAll: (type) =>
      associationMethod = type.className.toLowerCase() + 's' #e.g. Node -> nodes
      elements = @drawing[associationMethod]().all()         #e.g. @drawing.nodes().all()
      console.log("adding all " + elements.length + " " + type.className + "s")
      @draw(element, persist: false) for element in elements
  
    draw: (element, options={persist: true}) =>
      canvasElement = new CanvasElement(element, @)
      @elements[element.id] = canvasElement
      canvasElement.bind("destroy", => 
        delete @elements[element.id]
        @updateDrawingCache()
      )
      @updateDrawingCache() if options.persist
      canvasElement
  
    addNode: (parameters) =>
      node = @commander.run(new CreateNode(@drawing, parameters))
      @draw(node)
      
    addLink: (parameters) =>
      link = @commander.run(new CreateLink(@drawing, parameters))
      @draw(link)
        
    elementAt: (point) =>
      hitResult = paper.project.hitTest(point)
      if hitResult and hitResult.item.canvasElement
        hitResult.item.canvasElement 
      else 
        new NullCanvasElement(@)
  
    elementFor: (element) =>
      @elements[element.id]
  
    updateDrawingCache: =>
      @drawing.cache = @canvasElement.toDataURL()
      @drawing.save()
      
    clearSelection: =>
      paper.project.deselectAll()
      @drawing.clearSelection()
      
    selection: =>
      i.canvasElement for i in paper.project.selectedItems
      
    undo: =>
      @commander.undo()