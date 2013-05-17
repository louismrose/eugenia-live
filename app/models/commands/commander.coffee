class Commander
  run: (command) =>
    @command = command
    command.run()

  undo: =>
    if @command
      @command.undo()
      @command = null
  
module.exports = Commander