### LinkCanvasElement
This class is responsible for binding [Lines](paths/line.litcoffee) to Links.

    define [
      'viewmodels/drawings/canvas_element'
      'models/commands/delete_link'
      'models/commands/reshape_link'
    ], (CanvasElement, DeleteLink, ReshapeLink) ->

When the underlying Link is reshaped, the LinkCanvasElement causes the shape of
the corresponding Line to be updated.

      class LinkCanvasElement extends CanvasElement
        constructor: (@_element, @_path, @_canvas) ->
          super
          @_element.bind("reshape", @_updateShape)
      
        isNode: =>
          false
          
        _updateShape: =>
          @_path.setSegments(@_element.segments)
          @_canvas.updateDrawingCache()

A LinkCanvasElement exposes `_reconnectTo` and `_reshapeCommand` methods to
[NodeCanvasElement](node_canvas_element.litcoffee), so that the view can request
that changes to a Node's position can be persisted.

        _reconnectTo: (node, offset) =>
          @_path.reshape(offset, @_element.isSource(node), @_element.isTarget(node))
  
        _reshapeCommand: () =>
          new ReshapeLink(@_element, @_element.segments, @_path.segments())

A LinkCanvasElement exposes a `_destroyCommand` method to 
[CanvasElement](canvas_element.litcoffee), so that the view can request that
a Link is destroyed.
          
        _destroyCommand: (drawing) =>
          new DeleteLink(drawing, @_element)