require = window.require

describe 'DeleteNode', ->
  DeleteNode = require('models/commands/delete_node')
  Drawing = require('models/drawing')

  beforeEach ->
    @drawing = new Drawing()
    @parameters =
      shape: "State"
      position:
        x: 10
        y: 30
    @node = @drawing.addNode(@parameters)
    @command = new DeleteNode(@drawing, @node)

  afterEach -> # only needed because Spine saves data to the web browser's local storage!
    @drawing.destroy() if @drawing


  describe 'when node has no links', ->
    it 'deletes the node when executed', ->
      @command.run()
      expect(@drawing.nodes().all().length).toBe(0)
    
    it 'recreates the node when undone', ->
      @command.run()
      @command.undo()
    
      expect(@drawing.nodes().all().length).toBe(1)
      expect(@drawing.nodes().first().shape).toEqual(@parameters.shape)
      expect(@drawing.nodes().first().position).toEqual(@parameters.position)


  describe 'when node has some links', ->
    beforeEach ->
      @linkParameters =
        sourceId: @node.id
        targetId: @node.id
      @drawing.addLink(@linkParameters)

    it 'deletes the node and its links when executed', ->
      @command.run()
      expect(@drawing.nodes().all().length).toBe(0)
      expect(@drawing.links().all().length).toBe(0)
    
    it 'recreates the node and its links when undone', ->
      @command.run()
      @command.undo()
    
      expect(@drawing.nodes().all().length).toBe(1)
      
      node = @drawing.nodes().first()
      expect(node.shape).toEqual(@parameters.shape)
      expect(node.position).toEqual(@parameters.position)
      
      expect(node.links().length).toBe(1)