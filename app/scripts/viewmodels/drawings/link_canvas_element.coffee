define [
  'viewmodels/drawings/canvas_element'
  'viewmodels/drawings/stencils/stencil_factory'
  'models/commands/delete_link'
  'models/commands/reshape_link'
], (CanvasElement, StencilFactory, DeleteLink, ReshapeLink) ->

  class LinkCanvasElement extends CanvasElement
    isNode: =>
      false
    
    reconnectTo: (node, offset) =>
      @_path.move(offset, @_element.isSource(node), @_element.isTarget(node))
      new ReshapeLink(@_element, @_element.segments, @_path.segments())

    _destroyCommand: (drawing) =>
      new DeleteLink(drawing, @_element)