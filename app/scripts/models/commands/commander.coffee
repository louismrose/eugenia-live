define [], ->

  class Commander
    constructor: ->
      @history = []
  
    add: (command) =>
      @history.push command
  
    run: (command, options={undoable: true}) =>
      @add(command) if options.undoable
      command.run()

    undo: =>
      @history.pop().undo() if @history.length
  