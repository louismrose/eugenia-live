define [
  'viewmodels/drawings/tools/node_tool'
  'viewmodels/drawings/canvas'
], (NodeTool, Canvas)  ->

  describe 'NodeTool', ->
    beforeEach ->
      @canvas = jasmine.createSpyObj('canvas', ['addNode', 'clearSelection'])
      @tool = new NodeTool(canvas: @canvas)
      @tool.setParameter("shape", "a-shape")

    it 'creates a new node', ->
      @tool.onMouseDown(
        point:
          x: 1
          y: 2
      )
    
      expect(@canvas.addNode).toHaveBeenCalledWith(
        shape: 'a-shape'
        position:
          x: 1
          y: 2
      )
  