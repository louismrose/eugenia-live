require = window.require

describe 'Commander', ->
  Commander = require('models/commands/commander')

  beforeEach ->
    @commander = new Commander
    @command = jasmine.createSpyObj('command', ['run', 'undo'])

  it 'run delegates to the command', ->
    @commander.run(@command)
    expect(@command.run).toHaveBeenCalled()
    
  it 'undo delegates to the last command to have been run', ->
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
    
  
  it 'undo does nothing when there are no commands left to undo', ->
    @commander.run(@command)
    @commander.undo()
    @commander.undo()
    expect(@command.undo.callCount).toBe(1)