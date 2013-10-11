define [
  'controllers/node_tool'
  'models/commands/commander'
], (NodeTool, Commander)  ->

  class MockContainer
    addNode: ->
    
  class MockDrawing extends MockContainer
    select: (item) ->
      @selection = [item]
    
    clearSelection: ->
      @selection = []
      

  describe 'NodeTool', ->
    beforeEach ->
      @commander = new Commander
      @drawing = new MockDrawing
      @tool = new NodeTool(commander: @commander, drawing: @drawing)
      @tool.setParameter("shape", "a-shape")

    it 'creates a new node', ->
      spyOn(@drawing, 'addNode')
  
      @tool.onMouseDown(
        point:
          x: 1
          y: 2
      )
    
      expect(@drawing.addNode).toHaveBeenCalledWith(
        shape: 'a-shape'
        position:
          x: 1
          y: 2
      )
  