define [
  'models/commands/move_node'
  'models/node'
], (MoveNode , Node) ->

  describe 'MoveNode', ->
    MoveNode = require('models/commands/move_node')
    Node = require('models/node')

    beforeEach ->
      @source = { x: 10, y: 30 }
      @target = { x: 15, y: 20 }
    
      @node = new Node(position: @source)
      @command = new MoveNode(@node, @source, @target)


    it 'moves the node to the target when executed', ->
      @command.run()
      expect(@node.position.x).toBe(@target.x)
      expect(@node.position.y).toBe(@target.y)
  
    it 'moves the node back to the source when undone', ->
      @command.run()
      @command.undo()
  
      expect(@node.position.x).toBe(@source.x)
      expect(@node.position.y).toBe(@source.y)
