define [], ->

  class CreateLink
    constructor: (@drawing, @parameters) ->
  
    run: =>
      @link = @drawing.addLink(@parameters)
  
    undo: =>
      @link.destroy()