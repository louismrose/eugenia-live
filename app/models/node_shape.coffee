Spine = require('spine')

class Label
  constructor: (definition) ->
    @definition = definition
    
    if @definition
      @definition.for = [@definition.for] unless @definition.for instanceof Array
      @definition.pattern = @default_pattern() unless @definition.pattern
    else
      @definition = { placement: "none" }
  
  default_pattern: ->
    numbers = [0..@definition.for.length-1]
    formattedNumbers = ("{#{n}}" for n in numbers)
    formattedNumbers.join(",")
  
  draw: (node, shape) ->
    result = new paper.Group(shape)
    
    unless @definition.placement is "none"
      position = @positionFor(shape)
      result.addChild(@createText(node, position))
    
    result  
  
  positionFor: (shape) ->
    if @definition.placement is "external"
      shape.bounds.bottomCenter.add([0, 20]) # nudge outside shape
    else
      shape.position.add([0, 5]) # nudge down to middle of shape

  createText: (node, position) ->
    text = new paper.PointText(position)
    text.justification = 'center'
    text.fillColor = @definition.color
    text.content = @contentFor(node)
    text
  
  contentFor: (node) ->
    content = @definition.pattern    
    for number in [0..@definition.for.length-1]
      pattern = ///
        \{
        #{number}
        \}
      ///g
      value = node.getPropertyValue(@definition.for[number])
      content = content.replace(pattern, value)
    
    @trimText(content)
  
  trimText: (text) ->
    return "" unless text
    return text unless text.length > @definition.length
    return text.substring(0, @definition.length-3).trim() + "..."
      


class Elements
  constructor: (elements) ->
    @elements = elements
    
  draw: (node) ->
    children = (@createElement(e, node.position) for e in @elements)
    new paper.Group(children)

  createElement: (e, position) =>
    path = @createPath(e.figure, e.size)
    path.position = position
    path.fillColor = e.fillColor
    path.strokeColor = e.borderColor
    path

  createPath: (figure, size) =>
    switch figure
      when "rounded"
        rect = new paper.Rectangle(0, 0, size.width, size.height)
        new paper.Path.RoundRectangle(rect, new paper.Size(10, 10))
      when "circle"
        new paper.Path.Circle(0, 0, size.width)
      when "rectangle"
        new paper.Path.Rectangle(0, 0, size.width, size.height)


class NodeShape extends Spine.Model
  @configure "NodeShape", "name", "properties", "label", "elements"
  @belongsTo 'palette', 'models/palette'
  @extend Spine.Model.Local
  
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
    
module.exports = NodeShape