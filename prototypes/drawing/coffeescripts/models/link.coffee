###
  @depend element.js
###
class grumble.Link extends Spine.Model
  @configure "Link", "sourceId", "targetId", "segments", "strokeColor", "strokeStyle"
  @extend Spine.Model.Local
  
  # TODO duplication with grumble.Node
  constructor: (attributes) ->
    super
    @k = v for k,v of attributes
    @bind "save", @addToNodes
    @bind "destroy", @removeFromNodes
  
  addToNodes: =>
    @source().addLink(@id)
    @target().addLink(@id)
    
  removeFromNodes: =>
    @source().removeLink(@id) if grumble.Node.exists(@sourceId)
    @target().removeLink(@id) if grumble.Node.exists(@targetId)

  source: =>
    grumble.Node.find(@sourceId)
  
  target: =>
    grumble.Node.find(@targetId)