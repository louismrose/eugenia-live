define [
], () ->

  class PropertySetExpression
    @appliesFor: (expression) ->
      typeof expression is "string" and 
      @_propertyFrom(expression) isnt undefined
    
    @_propertyFrom: (expression) ->
      match = expression.match(/\$\{([^\}]*)\}/)
      match[1] if match
    
    constructor: (expression, @properties) ->
      @property = PropertySetExpression._propertyFrom(expression) 
      
    evaluate: ->
      @_coerce(@properties.get(@property))

    # Eventually, we probably want to store type information
    # for parameter values so that we can perform a more
    # knowledgable conversion, rather than use trial-and-error
    _coerce: (rawValue) ->
      return undefined unless rawValue
      value = parseInt(rawValue, radix = 10)
      value = rawValue if isNaN(value)
      value