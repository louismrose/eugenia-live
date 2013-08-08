define [
  'models/link'
  'models/node'
  'views/drawings/link_renderer'
  'views/drawings/node_renderer'
  'views/drawings/element_renderer'
], (Link, Node) ->

  class CanvasRenderer
    constructor: (options) ->
      @canvas = options.canvas
      @drawing = options.drawing
    
      paper.setup(@canvas)
      @bindToChangeEvents()
      @addAll(Node)
      @addAll(Link)
      
    bindToChangeEvents: =>
      Node.bind("refresh", => @addAll(Node))
      Link.bind("refresh", => @addAll(Link))
      Node.bind("create", @addOne)
      Link.bind("create", @addOne)
  
    addAll: (type) =>
      associationMethod = type.className.toLowerCase() + 's' #e.g. Node -> nodes
      elements = @drawing[associationMethod]().all()         #e.g. @drawing.nodes().all()
      console.log("adding all " + elements.length + " " + type.className + "s")
      @renderOne(element) for element in elements
      @updateDrawingCache()
  
    addOne: (element) =>
      @renderOne(element)
      @updateDrawingCache()
  
    renderOne: (element) =>
      renderer = require("views/drawings/#{element.constructor.className.toLowerCase()}_renderer")
    
      if (renderer)
        new renderer(element).render()      
      else
        console.warn("no renderer attached for " + element)
  
    updateDrawingCache: =>
      @drawing.cache = @canvas.toDataURL()
      @drawing.save()