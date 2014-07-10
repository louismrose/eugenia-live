### NodeCanvasElement
This class is responsible for binding [Paths](paths/path.litcoffee) to Nodes.

    define [
      'viewmodels/drawings/canvas_element'
      'models/commands/delete_node'
      'models/commands/composite_command'
      'models/commands/move_node'
    ], (CanvasElement, DeleteNode, CompositeCommand, MoveNode) ->

When the underlying Node is moved, the NodeCanvasElement causes the position of
the corresponding Path to be updated.

      class NodeCanvasElement extends CanvasElement
        constructor: (@_element, @_path, @_canvas) ->
          super
          @_element.bind("move", @_updatePosition)
    
        isNode: =>
          true

A NodeCavasElement exposes the `moveBy` method to the view to allow requests
to change a Path's position and (optionally) for the change in position to 
be persisted to the underlying Node.

        moveBy: (point, options={persist: true}) =>
          @_path.move(point)
          link._reconnectTo(@_element, point) for link in @_links()
          @_canvas.run(@_moveCommand()) if options.persist

        _updatePosition: =>
          @_path.setPosition(@_element.position)
          @_canvas.updateDrawingCache()

        _links: =>
          @_canvas.elementFor(link) for link in @_element.links()   

Persisting the change of position of a Node involves issuing commands both to 
move the Node and to reconnect any incoming or outgoing Links to the new
position of the Node.
    
        _moveCommand: =>
          commands = (link._reshapeCommand() for link in @_links())
          commands.push(new MoveNode(@_element, @_element.position, @_path.position()))
          new CompositeCommand(commands)

A NodeCavasElement exposes a `_destroyCommand` method to 
[CanvasElement](canvas_element.litcoffee), so that the view can request that
a Node is destroyed.

        _destroyCommand: (drawing) =>
          new DeleteNode(drawing, @_element)

