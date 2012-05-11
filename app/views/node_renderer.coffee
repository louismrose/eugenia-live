ElementRenderer = require('views/element_renderer')

class NodeRenderer extends ElementRenderer

  constructor: (item) ->
    super(item)

  draw: =>
    switch @item.shape
      when "rectangle" then @el = new paper.Path.Rectangle(@item.position, new paper.Size(100, 50))
      when "circle" then @el = new paper.Path.Circle(@item.position, 50)
      when "star" then @el = new paper.Path.Star(@item.position, 5, 20, 50)

    @el.position = @item.position
    @el.fillColor = @item.fillColor
    @el.strokeColor = @item.strokeColor
    @el.dashArray = if @item.strokeStyle is 'solid' then [10, 0] else [10, 4]
    
module.exports = NodeRenderer