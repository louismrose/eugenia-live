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
      # Don't call save() during initialisation, as this causes
      # duplicate Spine records to be created.
      @updatePropertyValuesWithDefaultsFromShape(false)
      
    getAllProperties: ->
      @updatePropertyValuesWithDefaultsFromShape(true)
      @propertyValues

    updatePropertyValuesWithDefaultsFromShape: (persist) ->
      for property,value of @defaultPropertyValues()
        # insert the default value unless there is already a value for this property
        @setPropertyValue(property,value,persist) unless @hasPropertyValue(property)
      
      for property,value of @propertyValues
        # remove the current value unless this property is currently defined for this shape
        @removePropertyValue(property,persist) unless property of @defaultPropertyValues()
    
    defaultPropertyValues: ->
      if @getShape() then @getShape().defaultPropertyValues() else {}
  
    setPropertyValue: (property, value, persist = true) ->
      @propertyValues[property] = value
      @save() if persist
  
    removePropertyValue: (property, persist = true) ->
      delete @propertyValues[property]
      @trigger("propertyRemove")
      @save() if persist

    hasPropertyValue: (property) ->
      property of @propertyValues
  
    getPropertyValue: (property) ->
      @propertyValues[property]
    
    links: =>
      Link.select (link) => (link.sourceId is @id) or (link.targetId is @id)
      
    incomingLinks: =>
      Link.select (link) => (link.targetId is @id)
    
    outgoingLinks: =>
      Link.select (link) => (link.sourceId is @id)

    moveTo: (newPosition) =>
      @position = newPosition
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