define [], ->

  class DeleteLink
    constructor: (@drawing, @link) ->
  
    run: =>  
      @memento = @link.destroy()
  
    undo: =>
      @drawing.addLink(@memento)
    
    rebase: (oldId, newId) =>
      @memento.sourceId = newId if @memento.sourceId is oldId
      @memento.targetId = newId if @memento.targetId is oldId