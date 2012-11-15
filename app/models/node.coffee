Spine = require('spine')
Link = require('models/link')
NodeShape = require('models/node_shape')

class Node extends Spine.Model
  @configure "Node", "shape", "position", "propertyValues"
  @belongsTo 'drawing', 'models/drawing'
  @extend Spine.Model.Local
    
  constructor: (attributes) ->
    super
    @k = v for k,v of attributes
    @bind("destroy", @destroyLinks)
    @initialisePropertyValues()

  initialisePropertyValues: ->
    @propertyValues or= @nodeShape().defaultPropertyValues() if @nodeShape()
    @propertyValues or= {}
  
  setPropertyValue: (property, value) ->
    @propertyValues[property] = value
  
  getPropertyValue: (property) ->
    @propertyValues[property]
  
  destroyLinks: =>
    link.destroy() for link in @links()
    
  links: =>
    Link.select (link) => (link.sourceId is @id) or (link.targetId is @id)

  moveTo: (destination) =>
    link.reconnectTo(@id, destination.subtract(@position)) for link in @links()
    @position = destination

  paperId: =>
    "node" + @id

  toPath: =>
    path = @nodeShape().draw(@)
    path.name = @paperId()
    path
  
  select: (layer) =>
    layer.children[@paperId()].selected = true
    
  nodeShape: =>
    NodeShape.find(@shape) if @shape


module.exports = Node