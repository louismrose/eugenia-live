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
      
    resolve: (expression, defaultValue) ->
      if (typeof expression is 'string' or expression instanceof String) and expression.length and expression[0] is "$"
        # What happens if there is a problem with the expression
        # for example ${unknown} where unknown is not a property
        # that is defined for this shape
    
        # strip off opening the ${ and the closing }
        evalable = expression.substring(2, expression.length - 1)
        expression = @get(evalable)
  
        # What happens if this fails?
        if expression is ""
          defaultValue
        else
          # Eventually, we probably want to store type information
          # for parameter values so that we can perform a more
          # knowledgable conversion, rather than trial-and-error
          value = parseInt(expression,10)
          value = expression if isNaN(value)
          value
      else
        expression