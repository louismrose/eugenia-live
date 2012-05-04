###
  @depend ../namespace.js
###
class grumble.Link extends Spine.Model
  @configure "Link", "sourceId", "targetId", "segments", "strokeColor", "strokeStyle"
  @extend Spine.Model.Local
  
  # TODO duplication with grumble.Node
  constructor: (attributes) ->
    super
    @k = v for k,v of attributes
    @moveTo(attributes.segments)
    @bind "save", @addToNodes
    @bind "destroy", @removeFromNodes
  
  # extract the information needed to reconstruct
  # the path used to draw this link (and nothing more)
  moveTo: (segments) =>
    @segments = (for s in segments
      point: {x: s.point.x, y: s.point.y}
      handleIn: {x: s.handleIn.x, y: s.handleIn.y}
      handleOut: {x: s.handleOut.x, y: s.handleOut.y})
      
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