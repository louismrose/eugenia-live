require = window.require

describe 'Commander', ->
  Commander = require('models/commands/commander')

  beforeEach ->
    @commander = new Commander
    @command = jasmine.createSpyObj('command', ['run', 'undo'])

  it 'runs by delegating to the command', ->
    @commander.run(@command)
    expect(@command.run).toHaveBeenCalled()
    
  it 'undoes by delegating to the last command to have been run', ->
    @commander.run(@command)
    @commander.undo()
    expect(@command.undo).toHaveBeenCalled()

  it 'undoes all commands to have been run, in reverse order', ->
    c1 = jasmine.createSpyObj('command', ['run', 'undo'])
    c2 = jasmine.createSpyObj('command', ['run', 'undo'])
    c3 = jasmine.createSpyObj('command', ['run', 'undo'])
    
    @commander.run(c1)
    @commander.run(c2)
    @commander.run(c3)
    
    @commander.undo()
    expect(c3.undo.callCount).toBe(1)
    @commander.undo()
    expect(c2.undo.callCount).toBe(1)
    @commander.undo()
    expect(c1.undo.callCount).toBe(1)
    
  it 'does not undo when there are no commands left to undo', ->
    @commander.run(@command)
    @commander.undo()
    @commander.undo()
    expect(@command.undo.callCount).toBe(1)
 
 
  describe 'run with undoable set to false', ->
    it 'does not undo commands', ->
      @commander.run(@command, undoable: false)
      @commander.undo()
      expect(@command.undo).not.toHaveBeenCalled()
 
    it 'does undo the last undoable command', ->
      uc = jasmine.createSpyObj('command', ['run', 'undo'])
      nuc = jasmine.createSpyObj('command', ['run', 'undo'])
      
      @commander.run(uc, undoable: true)
      @commander.run(nuc, undoable: false)
      @commander.undo()
      expect(uc.undo).toHaveBeenCalled()
 
  describe 'add', ->
    it 'does not run commands', ->
      @commander.add(@command)
      expect(@command.run).not.toHaveBeenCalled()
  
    it 'does prepare commands to be undone', ->
      @commander.add(@command)
      @commander.undo()
      expect(@command.undo).toHaveBeenCalled()