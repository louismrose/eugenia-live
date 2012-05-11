#Spine = require('spine')
Link = require('models/link')
NodeShape = require('models/node_shape')

class Node extends Spine.Model
  @configure "Node", "shape", "position"
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

  toPath: =>
    s = NodeShape.findByAttribute("name", @shape)
    path = s.draw(@position)
    path


module.exports = Node