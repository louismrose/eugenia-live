Spine = require('spine')
Link = require('models/link')
NodeShape = require('models/node_shape')

class Node extends Spine.Model
  @configure "Node", "shape", "position", "propertyValues"
  @belongsTo 'drawing', 'models/drawing'
    
  constructor: (attributes) ->
    super
    @k = v for k,v of attributes
    @initialisePropertyValues()

  initialisePropertyValues: ->
    @propertyValues or= @nodeShape().defaultPropertyValues() if @nodeShape()
    @propertyValues or= {}
  
  setPropertyValue: (property, value) ->
    @propertyValues[property] = value
  
  getPropertyValue: (property) ->
    @propertyValues[property]
    
  links: =>
    Link.select (link) => (link.sourceId is @id) or (link.targetId is @id)

  moveBy: (distance) =>
    @position = distance.add(@position)
    link.reconnectTo(@id, distance) for link in @links()
    @save()

  paperId: =>
    "node" + @id

  toPath: =>
    path = @nodeShape().draw(@)
    path.name = @paperId()
    path
  
  select: (layer) =>
    layer.children[@paperId()].selected = true
  
  destroy: (options = {}) =>
    destroyed = super(options)
    memento =
      shape: destroyed.shape
      position: destroyed.position
  
  nodeShape: =>
    NodeShape.find(@shape) if @shape and NodeShape.exists(@shape)

module.exports = Node