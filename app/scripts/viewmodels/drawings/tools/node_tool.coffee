define [
  'viewmodels/drawings/tools/tool'
], (Tool) ->

  class NodeTool extends Tool
    parameters: {'shape' : null}
  
    activate: =>
      super
      @canvas.clearSelection()
  
    onMouseDown: (event) =>
      if @parameters.shape
        @parameters.position = { x: event.point.x, y: event.point.y }
        @canvas.addNode(@parameters)