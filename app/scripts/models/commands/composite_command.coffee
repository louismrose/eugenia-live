define [], (CompositeCommand) ->

  class CompositeCommand
    constructor: (@children) ->
  
    run: =>
      c.run() for c in @children
  
    undo: =>
      c.undo() for c in @children