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
      @propertyValues or= @getShape().defaultPropertyValues() if @getShape()
      @propertyValues or= {}
  
    setPropertyValue: (property, value) ->
      @propertyValues[property] = value
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