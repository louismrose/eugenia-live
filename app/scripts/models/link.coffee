define [
  'require'
  'spine'
  'models/link_shape'
  'models/property_set'
  'spine.relation'
], (require, Spine, LinkShape, PropertySet) ->

  class Link extends Spine.Model
    @configure "Link", "sourceId", "targetId", "segments", "shape", "propertyValues"
    @belongsTo 'drawing', 'models/drawing'
  
    # TODO duplication with Node
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
    
    reshape: (newSegments) =>
      @segments = newSegments
      @save()
      @trigger("reshape")
  
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
      
    select: =>
      @drawing().select(@)