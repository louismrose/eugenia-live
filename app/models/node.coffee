Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1

#Spine = require('spine')
Link = require('models/link')

class Node extends Spine.Model
  @configure "Node", "shape", "position", "fillColor", "strokeColor", "strokeStyle"
  @extend Spine.Model.Local
    
  constructor: (attributes) ->
    super
    @k = v for k,v of attributes
    @bind("destroy", @destroyLinks)
  
  destroyLinks: =>
    link.destroy() for link in @links()
    
  links: =>
    Link.select (link) => (link.sourceId is @id) or (link.targetId is @id)

  moveTo: (destination) =>
    link.reconnectTo(@id, destination.subtract(@position)) for link in @links()
    @position = destination

module.exports = Node