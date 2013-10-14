define [], ->

  class LoggingCommander
    constructor: (@delegate) ->
    
    add: (command) =>
      @delegate.add(command)
  
    run: (command) =>
      @delegate.run(command)
      @log("Run", command)
  
    undo: (command) =>
      @delegate.undo(command)
      @log("Undo", command)
  
    log: (prefix, command) =>
      console.log(prefix + ": " + JSON.stringify(command))