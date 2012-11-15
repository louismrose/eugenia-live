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

  beforeEach ->
    @drawing = new MockDrawing
    @tool = new NodeTool(drawing: @drawing)
    @tool.setParameter("shape", "a-shape")

  it 'creates a new node', ->
    spyOn(@drawing, 'addNode')
  
    @tool.onMouseDown({point: "dummy-position"})
    
    expect(@drawing.addNode).toHaveBeenCalledWith(
      shape : 'a-shape'
      position : "dummy-position"
    )

    
    