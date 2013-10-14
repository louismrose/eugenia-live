define [
  'paper'
], (paper) ->

  class Tool
    constructor: (options) ->
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
  
    onKeyDown: (event) =>
      # don't intercept key events if any DOM element
      # (e.g. form field) has focus
      if (document.activeElement is document.body)      
        if (event.key is 'delete')
          e.remove() for e in @canvas.selection()
          @canvas.clearSelection()

        else if (event.key is 'z')
          @canvas.undo()