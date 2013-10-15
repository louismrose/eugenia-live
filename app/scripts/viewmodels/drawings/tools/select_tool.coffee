define [
  'viewmodels/drawings/tools/tool'
], (Tool) ->

  class SelectTool extends Tool
    parameters: {}
  
    onMouseDown: (event) =>
      @canvas.elementAt(event.point).select()
      @current = event.point
      @start = event.point
      
    onMouseDrag: (event) =>
      for item in @canvas.selection() when item.isNode()
        item.moveBy(event.point.subtract(@current), persist: false)
        @current = event.point
  
    onMouseUp: (event) =>
      for item in @canvas.selection() when item.isNode()
        item.moveBy(event.point.subtract(@current), persist: true)