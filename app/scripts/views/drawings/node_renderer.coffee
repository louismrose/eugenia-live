ElementRenderer = require('views/drawings/element_renderer')

class NodeRenderer extends ElementRenderer

  constructor: (item) ->
    super(item)

  draw: =>
    @el = @item.toPath()
      
module.exports = NodeRenderer