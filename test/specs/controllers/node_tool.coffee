require = window.require

class MockContainer
  addNode: ->
    
class MockDrawing extends MockContainer
  select: (item) ->
    @selection = [item]
    
  clearSelection: ->
    @selection = []

describe 'NodeTool', ->
  NodeTool = require('controllers/node_tool')
  Commander = require('models/commands/commander')

  beforeEach ->
    @commander = new Commander
    @drawing = new MockDrawing
    @tool = new NodeTool(commander: @commander, drawing: @drawing)
    @tool.setParameter("shape", "a-shape")

  it 'creates a new node', ->
    spyOn(@drawing, 'addNode')
  
    @tool.onMouseDown({point: "dummy-position"})
    
    expect(@drawing.addNode).toHaveBeenCalledWith(
      shape : 'a-shape'
      position : "dummy-position"
    )

    
    