define [
  'require'
  'spine'
  'models/link_shape'
  'spine.relation'
], (require, Spine, LinkShape) ->

  class Link extends Spine.Model
    @configure "Link", "sourceId", "targetId", "segments", "shape", "propertyValues"
    @belongsTo 'drawing', 'models/drawing'
  
    # TODO duplication with Node
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
  
    reshape: (newSegments) =>
      @segments = newSegments
      @save()
  
    toPath: =>
      @getShape().draw(@)

    destroy: (options = {}) =>
      destroyed = super(options)
      memento =
        sourceId: destroyed.sourceId
        targetId: destroyed.targetId
        segments: destroyed.segments
        shape: destroyed.shape
        
    getShape: =>
      LinkShape.find(@shape) if @shape and LinkShape.exists(@shape)
    
    source: =>
      # Avoid circular dependencies with dynamic require
      Node = require('models/node')
      Node.find(@sourceId)

    target: =>
      # Avoid circular dependencies with dynamic require
      Node = require('models/node')
      Node.find(@targetId)