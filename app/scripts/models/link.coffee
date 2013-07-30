define [
  'spine'
  'models/moves_path'
  'models/link_shape'
  'spine.relation'
], (Spine, MovesPath, LinkShape) ->

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
  
    select: ->
      @drawing().select(@)
  
    reconnectTo: (nodeId, offset) =>
      mover = new MovesPath(@toPath().firstChild, offset)
      mover.moveStart() if nodeId is @sourceId
      mover.moveEnd() if nodeId is @targetId
      @segments = mover.finalise()
      @save()
  
    paperId: =>
      "link" + @id
      
    toPath: =>
      path = @getShape().draw(@)
      path.name = @paperId()
      path

    select: (layer) =>
      layer.children[@paperId()].selected = true

    destroy: (options = {}) =>
      destroyed = super(options)
      memento =
        sourceId: destroyed.sourceId
        targetId: destroyed.targetId
        segments: destroyed.segments
        shape: destroyed.shape
        
    getShape: =>
      LinkShape.find(@shape) if @shape and LinkShape.exists(@shape)