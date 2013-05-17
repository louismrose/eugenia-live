DeleteNode = require('models/commands/delete_node')
DeleteLink = require('models/commands/delete_link')
Node = require('models/node')

class DeleteElement
  constructor: (drawing, element) ->
    if element instanceof Node
      @delegate = new DeleteNode(drawing, element)
    else
      @delegate = new DeleteLink(drawing, element)
  
  run: =>
    @delegate.run()
  
  undo: =>
    @delegate.undo()
    
module.exports = DeleteElement