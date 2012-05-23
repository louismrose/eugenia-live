Link = require('models/link')
Node = require('models/node')

class CanvasRenderer
  constructor: (options) ->
    @canvas = options.canvas
    @drawing = options.drawing
    
    paper.setup(@canvas)
    @bindToChangeEvents()
    @addAll(Node)
    @addAll(Link)
    paper.view.draw()
  
  bindToChangeEvents: =>
    Node.bind("refresh", => @addAll(Node))
    Link.bind("refresh", => @addAll(Link))
    Node.bind("create", @addOne)
    Link.bind("create", @addOne)
  
  addAll: (type) =>
    associationMethod = type.className.toLowerCase() + 's' #e.g. Node -> nodes
    elements = @drawing[associationMethod]().all()         #e.g. @drawing.nodes().all()
    console.log("adding all " + elements.length + " " + type.className + "s")
    @addOne(element) for element in elements
  
  addOne: (element) =>
    renderer = require("views/#{element.constructor.className.toLowerCase()}_renderer")
    
    if (renderer)
      new renderer(element).render()
    else
      console.warn("no renderer attached for " + element)
      
module.exports = CanvasRenderer