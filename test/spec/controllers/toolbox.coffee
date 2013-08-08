define [
  'controllers/toolbox'
], (Toolbox)  ->

  describe 'Toolbox', ->
    beforeEach -> @t = new Toolbox(commander: {})

    it 'switches to SelectTool when initialised', ->
      expect(@t.currentTool).toBe(@t.tools.select)
  
    it 'activates specified tool after switching', ->
      @t.switchTo('node')
      expect(@t.currentTool).toBe(@t.tools.node)

    it 'errors when switching to an unknown tool', ->
      expect( => @t.switchTo('detonator')).toThrow("There is no tool named 'detonator'")
  