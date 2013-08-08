define [
  'models/commands/move_node'
  'models/node'
], (MoveNode , Node) ->

  describe 'MoveNode', ->
    MoveNode = require('models/commands/move_node')
    Node = require('models/node')

    beforeEach ->
      @position = { x: 10, y: 30 }
      @offset = { x: 5, y: -10 }
    
      @node = new Node(position: @position)
      @command = new MoveNode(@node, @offset)


    it 'moves the node when executed', ->
      @command.run()
      expect(@node.position.x).toBe(@position.x + @offset.x)
      expect(@node.position.y).toBe(@position.y + @offset.y)
  
    it 'recreates the node when undone', ->
      @command.run()
      @command.undo()
  
      expect(@node.position.x).toBe(@position.x)
      expect(@node.position.y).toBe(@position.y)
