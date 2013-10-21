define [
  'models/commands/composite_command'
], (CompositeCommand) ->

  describe 'CompositeCommand', ->
    beforeEach ->
      @child1 = jasmine.createSpyObj('command', ['run', 'undo'])
      @child2 = jasmine.createSpyObj('command', ['run', 'undo'])
      @child3 = jasmine.createSpyObj('command', ['run', 'undo'])
      @command = new CompositeCommand([@child1, @child2, @child3])

    it 'run delegates to run of every child', ->
      @command.run()
      
      expect(@child1.run.callCount).toBe(1)
      expect(@child2.run.callCount).toBe(1)
      expect(@child3.run.callCount).toBe(1)
    
    it 'undo delegates to undo of every child', ->  
      @command.undo()
    
      expect(@child3.undo.callCount).toBe(1)
      expect(@child2.undo.callCount).toBe(1)
      expect(@child1.undo.callCount).toBe(1)