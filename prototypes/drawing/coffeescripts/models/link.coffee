###
  @depend element.js
###
class grumble.Link extends Spine.Model
  @configure "Link", "segments", "strokeColor", "strokeStyle"
  @extend Spine.Model.Local
  
  # TODO duplication with grumble.Node
  constructor: (attributes) ->
    super
    this[k] = v for k,v of attributes
    this.bind "save", @updateNodes
  
  updateNodes: =>
    @source().addLink(@id) if @source_id
    @target().addLink(@id) if @source_id isnt @target_id

  source: =>
    grumble.Node.find(@source_id)
  
  target: =>
    grumble.Node.find(@target_id)