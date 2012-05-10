Link = require('models/link')
Node = require('models/node')

class CanvasRenderer
  install: =>
    @bindToChangeEvents()
    @fetchDrawing()
  
  bindToChangeEvents: =>
    Node.bind("refresh", => @addAll(Node))
    Link.bind("refresh", => @addAll(Link))
    Node.bind("create", @addOne)
    Link.bind("create", @addOne)
  
  fetchDrawing: (client) =>
    Node.fetch()
    Link.fetch()
  
  addAll: (type) =>
    console.log("adding all " + type.count() + " " + type.className + "s")
    type.each(@addOne)
  
  addOne: (element) =>
    renderer = require("views/#{element.constructor.className.toLowerCase()}_renderer")
    
    if (renderer)
      new renderer(element).render()
    else
      console.warn("no renderer attached for " + element)
      
module.exports = CanvasRenderer