define [
  'spine'
  'models/helpers/label'
  'spine.relation'
], (Spine, Label) ->

  class Elements
    constructor: (elements) ->
      @elements = elements
    
    draw: (node) ->
      children = (@createElement(e, node.position) for e in @elements)
      new paper.Group(children)

    createElement: (e, position) =>
      e.x or= 0
      e.y or= 0
      path = @createPath(e)
      path.position = new paper.Point(position).add(e.x, e.y)
      path.fillColor = e.fillColor
      path.strokeColor = e.borderColor
      path

    createPath: (options) =>
      switch options.figure
        when "rounded"
          rect = new paper.Rectangle(0, 0, options.size.width, options.size.height)
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


  class NodeShape extends Spine.Model
    @configure "NodeShape", "name", "properties", "label", "elements"
    @belongsTo 'palette', 'models/palette'
  
    constructor: (attributes) ->
      super
      @createDelegates()
      @bind("update", @createDelegates)
      @bind("destroy", @destroyNodes)
  
    createDelegates: =>
      @_elements = new Elements(@elements)
      @_label = new Label(@label)
  
    defaultPropertyValues: =>
      defaults = {}
      defaults[property] = "" for property in @properties if @properties
      defaults
  
    displayName: =>
      @name.charAt(0).toUpperCase() + @name.slice(1)
  
    draw: (node) =>
      @_label.draw(node, @_elements.draw(node))
      
    destroyNodes: ->
      node.destroy() for node in require('models/node').findAllByAttribute("shape", @id)