###
  @depend element.js
###
class grumble.Node extends Spine.Model
  @configure "Node", "link_ids", "shape", "position", "fillColor", "strokeColor", "strokeStyle"
  @extend Spine.Model.Local
    
  constructor: (attributes) ->
    super
    this[k] = v for k,v of attributes
    @link_ids or= []
    this.bind("destroy", @destroyLinks)
  
  addLink: (id) =>
    @link_ids.push id unless id in @link_ids
    @save()
  
  destroyLinks: =>
    grumble.Link.destroy(id) for id in @link_ids
