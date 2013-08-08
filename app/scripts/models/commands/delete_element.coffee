define [
  'models/commands/delete_node'
  'models/commands/delete_link'
  'models/node'
], (DeleteNode, DeleteLink, Node) ->

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