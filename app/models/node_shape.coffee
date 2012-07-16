Spine = require('spine')

class Label
  constructor: (pattern) ->
    @pattern = pattern
  
  draw: (node) ->
    text = new paper.PointText(node.position)
    text.justification = 'center'
    text.fillColor = 'red'
    text.content = @contentFor(node)
    text
  
  contentFor: (node) ->
    node[@pattern]


class Shapes
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
  @configure "NodeShape", "name", "elements"
  @belongsTo 'palette', 'models/palette'
  @extend Spine.Model.Local
  
  constructor: (attributes) ->
    super
    @shapes = new Shapes(@elements)
    @label = new Label("id")
    @bind("destroy", @destroyNodes)
  
  displayName: =>
    @name.charAt(0).toUpperCase() + @name.slice(1)
  
  draw: (node) =>
    new paper.Group(@shapes.draw(node), @label.draw(node))

  destroyNodes: ->
    node.destroy() for node in require('models/node').findAllByAttribute("shape", @id)
    
module.exports = NodeShape