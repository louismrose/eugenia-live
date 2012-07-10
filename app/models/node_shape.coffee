Spine = require('spine')

class NodeShape extends Spine.Model
  @configure "Shape", "name", "elements"
  @belongsTo 'palette', 'models/palette'
  @extend Spine.Model.Local
  
  constructor: (attributes) ->
    super
  
  displayName: =>
    @name.charAt(0).toUpperCase() + @name.slice(1)
  
  draw: (position) =>
    children = (@createElement(e, position) for e in @elements)
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
    
module.exports = NodeShape