define [
  'paper'
], (paper) ->

  class Elements
    constructor: (elements) ->
      @elements = elements
    
    draw: (node) ->
      children = (@createElement(e, node) for e in @elements)
      new paper.Group(children)

    createElement: (e, node) =>
      e.x or= 0
      e.y or= 0
      path = @createPath(e, node)
      path.position = new paper.Point(node.position).add(@getOption(e.x, node, 0), @getOption(e.y, node, 0))      
      path.fillColor = @getOption(e.fillColor, node, "white")
      path.strokeColor = @getOption(e.borderColor, node, "black")
      path

    createPath: (options, node) =>
      width = @getOption(options.size.width, node, 100) if options.size
      height = @getOption(options.size.height, node, 100) if options.size
      
      switch options.figure
        when "rounded"
          rect = new paper.Rectangle(0, 0, width, height)
          new paper.Path.RoundRectangle(rect, new paper.Size(10, 10))
        when "ellipse"
          rect = new paper.Rectangle(0, 0, width*2, height*2)
          new paper.Path.Oval(rect)
        when "rectangle"
          new paper.Path.Rectangle(0, 0, width, height)
        when "polygon"
          options.sides or= 3
          options.radius or= 50
          new paper.Path.RegularPolygon(new paper.Point(0, 0), options.sides, options.radius)
          
    getOption: (content, node, defaultValue) =>
      if (typeof content is 'string' or content instanceof String) and content.length and content[0] is "$"
        # What happens if there is a problem with the expression
        # for example ${unknown} where unknown is not a property
        # that is defined for this shape
        
        # strip off opening the ${ and the closing }
        evalable = content.substring(2, content.length - 1)
        content = node.properties.get(evalable)
      
        # What happens if this fails?
        if content is ""
          defaultValue
        else
          # Eventually, we probably want to store type information
          # for parameter values so that we can perform a more
          # knowledgable conversion, rather than trial-and-error
          value = parseInt(content,10)
          value = content if isNaN(value)
          value
      else
        content