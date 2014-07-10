define [
  'viewmodels/drawings/canvas_element'
  'viewmodels/drawings/stencils/stencil_factory'
  'models/commands/delete_link'
  'models/commands/reshape_link'
], (CanvasElement, StencilFactory, DeleteLink, ReshapeLink) ->

  class LinkCanvasElement extends CanvasElement
    constructor: (@_element, @_path, @_canvas) ->
      super(@_element, @_path, @_canvas)
      @_element.bind("reshape", =>
        @_path.setSegments(@_element.segments)
        @_canvas.updateDrawingCache()
      )
      
    isNode: =>
      false
    
    reconnectTo: (node, offset) =>
      @_path.reshape(offset, @_element.isSource(node), @_element.isTarget(node))
      new ReshapeLink(@_element, @_element.segments, @_path.segments())

    _destroyCommand: (drawing) =>
      new DeleteLink(drawing, @_element)