###
  @depend ../namespace.js
  @depend node_renderer.js
  @depend link_renderer.js
###
class grumble.CanvasRenderer
  install: =>
    grumble.Node.bind("refresh", => @addAll(grumble.Node))
    grumble.Link.bind("refresh", => @addAll(grumble.Link))
    grumble.Node.bind("create", @addOne)
    grumble.Link.bind("create", @addOne)
    grumble.Node.fetch()
    grumble.Link.fetch()
  
  addAll: (type) =>
    console.log("adding all " + type.count() + " " + type.name + "s")
    type.each(@addOne)
  
  addOne: (element) =>
    renderer = grumble[element.constructor.name + "Renderer"]
    
    if (renderer)
      new renderer(element).render()
    else
      console.warn("no renderer attached for " + element)