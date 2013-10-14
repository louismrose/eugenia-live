define [
  'spine'
], (Spine) ->

  class PropertySet extends Spine.Module
    @include(Spine.Events)
    
    constructor: (@shape, @propertyValues = {}) ->
      @updateDefaultsFromShape()
      
    all: ->
      @updateDefaultsFromShape()
      @propertyValues

    size: ->
      Object.keys(@propertyValues).length
    
    has: (property) ->
      property of @propertyValues

    get: (property) ->
      @propertyValues[property]

    set: (property, value) ->
      @propertyValues[property] = value
      @trigger("propertyChanged")
  
    remove: (property) ->
      delete @propertyValues[property]
      @trigger("propertyRemoved")

    updateDefaultsFromShape: () ->
      for property,value of @defaults()
        # insert the default value unless there is already a value for this property
        @set(property,value) unless @has(property)
      
      for property,value of @propertyValues
        # remove the current value unless this property is currently defined for this shape
        @remove(property) unless property of @defaults()
    
    defaults: ->
      if @shape then @shape.defaultPropertyValues() else {}