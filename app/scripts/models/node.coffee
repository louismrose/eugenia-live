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
      @propertyValues or= {}
      @updatePropertyValuesWithDefaultsFromShape()
  
    getAllProperties: ->
      @updatePropertyValuesWithDefaultsFromShape()
      @propertyValues

    updatePropertyValuesWithDefaultsFromShape: ->
      for property,value of @defaultPropertyValues()
        # insert the default value unless there is already a value for this property
        @setPropertyValue(property,value) unless property of @propertyValues
      
      for property,value of @propertyValues
        # remove the current value unless this property is currently defined for this shape
        @removePropertyValue(property) unless property of @defaultPropertyValues()
    
    defaultPropertyValues: ->
      if @getShape() then @getShape().defaultPropertyValues() else {}
    
    setPropertyValue: (property, value) ->
      @propertyValues[property] = value
      @save()
  
    removePropertyValue: (property) ->
      delete @propertyValues[property]
      @trigger("propertyRemove")
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