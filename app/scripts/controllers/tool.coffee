define [
  'paper'
  'models/node'
  'models/link'
  'models/commands/delete_element'
], (paper, Node, Link, DeleteElement) ->

  class Tool
    constructor: (options) ->
      @commander = options.commander
      @drawing = options.drawing
      @canvas = options.canvas
      
      @_tool = new paper.Tool
      @_tool.onMouseMove = @onMouseMove
      @_tool.onMouseDrag = @onMouseDrag
      @_tool.onMouseDown = @onMouseDown
      @_tool.onMouseUp = @onMouseUp
      @_tool.onKeyDown = @onKeyDown
      @_tool.onKeyUp = @onKeyUp
      
    activate: =>
      @_tool.activate()
  
    setParameter: (parameterKey, parameterValue) ->
      @parameters or= {}
      @parameters[parameterKey] = parameterValue
  
    run: (command, options={undoable: true}) ->
      @commander.run(command, options)

    onKeyDown: (event) =>
      # don't intercept key events if any DOM element
      # (e.g. form field) has focus
      if (document.activeElement is document.body)      
        if (event.key is 'delete')
          for e in @canvas.selection()
            e.remove()
            @run(new DeleteElement(@drawing, e.element))
          @clearSelection()

        else if (event.key is 'z')
          @commander.undo()

    changeSelectionTo: (nodeOrLink) ->
      @clearSelection()
      @select(nodeOrLink)

    clearSelection: ->
      @drawing.clearSelection()
  
    select: (nodeOrLink) ->
      @drawing.select(nodeOrLink)
  
    selection: ->
      @drawing.selection
