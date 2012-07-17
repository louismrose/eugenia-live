require = window.require

describe 'Toolbox', ->
  Toolbox = require('controllers/toolbox')

  beforeEach -> @t = new Toolbox()

  it 'switches to SelectTool when initialised', ->
    expect(@t.currentTool).toBe(@t.tools.select)
  
  it 'activates specified tool after switching', ->
    @t.switchTo('node')
    expect(@t.currentTool).toBe(@t.tools.node)

  it 'errors when switching to an unknown tool', ->
    expect( => @t.switchTo('detonator')).toThrow("There is no tool named 'detonator'")
  