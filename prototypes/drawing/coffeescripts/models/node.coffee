###
  @depend element.js
###
class grumble.Node extends Spine.Model
  @configure "Node", "linkIds", "shape", "position", "fillColor", "strokeColor", "strokeStyle"
  @extend Spine.Model.Local
    
  constructor: (attributes) ->
    super
    @k = v for k,v of attributes
    @linkIds or= []
    @bind("destroy", @destroyLinks)
  
  addLink: (id) =>
    @linkIds.push id unless id in @linkIds
    @save()
    
  removeLink: (id) ->
    @linkIds.remove(id)
  
  destroyLinks: =>
    grumble.Link.destroy(id) for id in @linkIds
    
  links: =>
    grumble.Link.find(id) for id in @linkIds
