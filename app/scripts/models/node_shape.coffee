define [
  'spine'
  'views/drawings/shapes/label'
  'spine.relation'
], (Spine, Label) ->

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
      width = @getOption(options.size.width, node, 100)
      height = @getOption(options.size.height, node, 100)
      
      switch options.figure
        when "rounded"
          rect = new paper.Rectangle(0, 0, width, height)
          new paper.Path.RoundRectangle(rect, new paper.Size(10, 10))
        when "ellipse"
          rect = new paper.Rectangle(0, 0, options.size.width*2, options.size.height*2)
          new paper.Path.Oval(rect)
        when "rectangle"
          new paper.Path.Rectangle(0, 0, options.size.width, options.size.height)
        when "polygon"
          options.sides or= 3
          options.radius or= 50
          new paper.Path.RegularPolygon(new paper.Point(0, 0), options.sides, options.radius)
        when "path"
          path = new paper.Path()
          for point in options.points
            path.add(new paper.Point(point.x, point.y))
          path
          
    getOption: (content, node, defaultValue) =>
      if (typeof content is 'string' or content instanceof String) and content.length and content[0] is "$"
        # What happens if there is a problem with the expression
        # for example ${unknown} where unknown is not a property
        # that is defined for this shape
        
        # strip off opening the ${ and the closing }
        evalable = content.substring(2, content.length - 1)
        content = node.getPropertyValue(evalable)
      
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


  class NodeShape extends Spine.Model
    @configure "NodeShape", "name", "properties", "label", "elements"
    @belongsTo 'palette', 'models/palette'
  
    constructor: (attributes) ->
      super
      @properties or= []
      @createDelegates()
      @bind("update", @createDelegates)
      @bind("destroy", @destroyNodes)
  
    createDelegates: =>
      @_elements = new Elements(@elements)
      @_label = new Label(@label)
  
    defaultPropertyValues: =>
      defaults = {}
      defaults[property] = "" for property in @properties
      defaults
  
    displayName: =>
      @name.charAt(0).toUpperCase() + @name.slice(1)
  
    draw: (node) =>
      @_label.draw(node, @_elements.draw(node))
      
    destroyNodes: ->
      node.destroy() for node in require('models/node').findAllByAttribute("shape", @id)