# Spine = require('spine')
Link = require('models/link')

Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1

class Node extends Spine.Model
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
    
  removeLink: (id) =>
    @linkIds.remove(id)
  
  destroyLinks: =>
    Link.destroy(id) for id in @linkIds
    
  links: =>
    Link.find(id) for id in @linkIds

module.exports = Node