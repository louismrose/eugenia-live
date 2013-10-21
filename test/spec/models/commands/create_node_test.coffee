define [
  'models/commands/create_node'
  'models/drawing'
], (CreateNode, Drawing) ->

  describe 'CreateNode', ->
    beforeEach ->
      @drawing = new Drawing()
      @parameters =
        shape: "State"
        position:
          x: 10
          y: 30
      @command = new CreateNode(@drawing, @parameters)

    afterEach -> # only needed because Spine saves data to the web browser's local storage!
      @drawing.destroy() if @drawing

    it 'creates a new node when executed', ->
      @command.run()
      expect(@drawing.nodes().all().length).toBe(1)
      expect(@drawing.nodes().first().shape).toEqual(@parameters.shape)
      expect(@drawing.nodes().first().position).toEqual(@parameters.position)
    
    it 'deletes the node when undone', ->
      @command.run()
      @command.undo()
      expect(@drawing.nodes().all().length).toBe(0)