define [
], () ->

  class PropertySetExpression
    @appliesFor: (expression) ->
      typeof expression is "string" and
      @_matchesFrom(expression).length
    
    @_matchesFrom: (expression) ->
      # Match all occurrences of ${foo}, defaulting to []
      expression.match(/\$\{([^\}]*)\}/g) or []
        
    constructor: (@expression, properties) ->
      @propertyReferences =
        for match in PropertySetExpression._matchesFrom(@expression)
          new PropertyReference(match, properties)
      
    evaluate: ->
      @_coerce(@_replaceReferencesForValuesIn(@expression))

    _replaceReferencesForValuesIn: (result) ->
      for propertyReference in @propertyReferences
        return undefined if propertyReference.isInvalid()
        result = propertyReference.replaceIn(result)
      result

    # Eventually, we probably want to store type information
    # for parameter values so that we can perform a more
    # knowledgable conversion, rather than use trial-and-error
    _coerce: (rawValue) ->
      return undefined unless rawValue
      value = parseInt(rawValue, radix = 10)
      value = rawValue if isNaN(value)
      value
  
  
  class PropertyReference
    constructor: (_ref, @_properties) ->
      # Remove leading ${ and trailing }
      @_propertyName = _ref.substring(2, _ref.length-1)
      @_pattern = new RegExp("\\$\\{" + @_propertyName + "\\}", 'g')
    
    replaceIn: (expression) ->
      expression.replace @_pattern, @_propertyValue()
    
    isInvalid: ->
      @_propertyValue() is undefined
    
    _propertyValue: ->
      @_properties.get(@_propertyName)
      
  
  # Export the PropertySetExpression class
  PropertySetExpression