define [], ->

  class LoggingCommander
    constructor: (@delegate) ->
    
    add: (command) =>
      @delegate.add(command)
  
    run: (command, options={undoable: true}) =>
      @delegate.run(command, options)
      @log("Run", command)
  
    undo: (command) =>
      @delegate.undo(command)
      @log("Undo", command)
  
    log: (prefix, command) =>
      console.log(prefix + ": " + JSON.stringify(command))