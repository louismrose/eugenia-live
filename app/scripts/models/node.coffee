define [
  'spine'
  'models/link'
  'models/node_shape'
  'spine.relation'
], (Spine, Link, NodeShape) ->
  
  class Node extends Spine.Model
    @configure "Node", "shape", "position", "propertyValues"
    @belongsTo 'drawing', 'models/drawing'
    
    constructor: (attributes) ->
      super
      @k = v for k,v of attributes
      @initialisePropertyValues()

    initialisePropertyValues: ->
      @propertyValues or= @getShape().defaultPropertyValues() if @getShape()
      @propertyValues or= {}
  
    setPropertyValue: (property, value) ->
      @propertyValues[property] = value
      @save()
  
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
      path = @getShape().draw(@)
      path.name = @paperId()
      path
  
    select: (layer) =>
      layer.children[@paperId()].selected = true
  
    destroy: (options = {}) =>
      destroyed = super(options)
      memento =
        shape: destroyed.shape
        position: destroyed.position
  
    getShape: =>
      NodeShape.find(@shape) if @shape and NodeShape.exists(@shape)