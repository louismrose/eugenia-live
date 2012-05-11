ElementRenderer = require('views/element_renderer')

class LinkRenderer extends ElementRenderer

  constructor: (item) ->
    super(item)

  draw: =>
    @el = @item.toPath()
    @el.spine_id = @item.id
    @el.strokeColor = @item.strokeColor
    @el.dashArray = if @item.strokeStyle is 'solid' then [10, 0] else [10, 4]

    # TODO trim the line in the tool
    # rather than hiding the overlap behind the nodes here
    @el.layer.insertChild(0, @el)
    
module.exports = LinkRenderer