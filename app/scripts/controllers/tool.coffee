define [
  'paper'
  'models/node'
  'models/link'
  'models/commands/delete_element'
], (Paper, Node, Link, DeleteElement) ->

  class PaperHitTester
    nodeOrLinkAt: (point) ->
      result = @nodeAt(point)
      result = @linkAt(point) unless result
      result
  
    linkAt: (point) ->
      @xAt(point, Link)
  
    nodeAt: (point) ->
      @xAt(point, Node)

    xAt: (point, type) ->
      hitResult = Paper.project.hitTest(point)
      hitResult.item.model if hitResult and (hitResult.item.model instanceof type)


  class Tool
    constructor: (options) ->
      @commander = options.commander
      @hitTester = options.hitTester
      @hitTester or= new PaperHitTester
      @drawing = options.drawing
      
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
          @run(new DeleteElement(@drawing, e)) for e in @selection()
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
