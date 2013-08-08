define [
  'views/drawings/element_renderer'
], (ElementRenderer) ->

  class LinkRenderer extends ElementRenderer
    constructor: (item) ->
      super(item)

    draw: =>
      @el = @item.toPath()
    
      # TODO trim the line in the tool
      # rather than hiding the overlap behind the nodes here
      paper.project.activeLayer.insertChild(0, @el)