class CreateNode
  constructor: (@drawing, @parameters) ->
  
  run: =>
    @node = @drawing.addNode(@parameters)
  
  undo: =>
    @node.destroy()
    
module.exports = CreateNode