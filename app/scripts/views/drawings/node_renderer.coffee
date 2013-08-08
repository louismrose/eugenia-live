define [
  'views/drawings/element_renderer'
], (ElementRenderer) ->

  class NodeRenderer extends ElementRenderer
    constructor: (item) ->
      super(item)

    draw: =>
      @el = @item.toPath()