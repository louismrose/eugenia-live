define [], ->

  class Commander
    constructor: ->
      @history = []
  
    run: (command) =>
      @history.push command
      command.run()

    undo: =>
      @history.pop().undo() if @history.length
  