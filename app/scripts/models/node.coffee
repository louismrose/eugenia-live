define [
  'spine'
  'models/link'
  'models/node_shape'
  'models/property_set'
  'spine.relation'
], (Spine, Link, NodeShape, PropertySet) ->
  
  class Node extends Spine.Model
    @configure "Node", "shape", "position", "propertyValues"
    @belongsTo 'drawing', 'models/drawing'
    
    constructor: (attributes) ->
      super
      @k = v for k,v of attributes
      @propertyValues or= {}
      @initialisePropertySet()
  
    initialisePropertySet: ->
      @properties = new PropertySet(@getShape(), @propertyValues)
      updatePropertyValues = =>
        @propertyValues = @properties.propertyValues
        @save()
      @properties.bind("propertyChanged propertyRemoved", updatePropertyValues)
  
    links: =>
      Link.select (link) => (link.sourceId is @id) or (link.targetId is @id)
      
    incomingLinks: =>
      Link.select (link) => (link.targetId is @id)
    
    outgoingLinks: =>
      Link.select (link) => (link.sourceId is @id)

    moveTo: (newPosition) =>
      @position = newPosition
      @save()

    toPath: =>
      @getShape().draw(@)
  
    destroy: (options = {}) =>
      destroyed = super(options)
      memento =
        shape: destroyed.shape
        position: destroyed.position
  
    getShape: =>
      NodeShape.find(@shape) if @shape and NodeShape.exists(@shape)
      
    select: =>
      @drawing().select(@)