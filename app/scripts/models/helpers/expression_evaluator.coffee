Node = require('models/node')
Link = require('models/link')

class ExpressionEvaluator

  constructor: () ->
    # do nothing

  getValue: (expression, context, environment) ->
    switch true
      when expression is "time"
        return environment.simulationController.time

  ###
  # Extracts the target element (relative to the context object) and propertyName from an expression string.
  #
  # The source should be a Node or a Link
  #
  # Returns a map containing the target element and the property name that have been extracted
  ###
  getProperty: (expression, context, environment) ->
    environment or= {}

    # allows lists
    if context instanceof Array
      return context.map(@getProperty)

    Node = require('models/node')

    parts = expression.split '.'

    if parts.length is 1
      if context instanceof Node or context instanceof Link
        target = [context]
        # check if this element has this propertyValue:
        propertyName = expression
        throw new Error("Element does not contain that property") unless context.hasPropertyValue expression
      else
        throw new Error('Element is not of type Node or Link and cannot contain a Property')
    else
      lastDot = expression.lastIndexOf '.'
      # get the target element that is denoted by the first piece of the expression
      target = @getElements(expression[0..lastDot-1], context)
      # assert that the result is (a list of) Nodes/Links here?
      propertyName = expression.substr(lastDot+1)

    return {
      target: target,
      propertyName: propertyName
    }

  ###
  # Get (a list of) the elements that are referenced
  ###
  getElements: (expression, context, environment) ->
    environment or= {}
    firstDot = expression.indexOf '.'
    
    expressionParts = expression.split '.'
    sourceExpression = expressionParts[0]
    skipFirst = true
    if sourceExpression is 'self'
      source = [context]
    else if sourceExpression of environment
      source = [environment[sourceExpression]]
    else
      # assume the first part should be the context and the first part is already a sub-expression
      skipFirst = false
      source = [context]

    # what to do with access expressions? i.e. stuff between [ and ]
    firstPart = true
    for part in expression.split '.'
      if skipFirst and firstPart
        firstPart = false
        continue
      # apply part expression to source
      switch true
        # special cases first
        when part.trim().toLowerCase() is 'outgoing'
          sources = source.map (el)->el.outgoingLinks()
          # FIXME: what about non-unique occurrences, need to have them twice?
          # e.g. from N1--L1-->N2 and N1--L2-->N3--L3-->N2
          # where N1.outgoing.target().outgoing.target() would include N2 twice
          source = source.map((el)->el.outgoingLinks()).reduce((a, b)-> a.concat(b))
        when part.trim().toLowerCase() is 'incoming'
          source = source.map((el)->el.incomingLinks()).reduce((a, b)-> a.concat(b))
        when part.indexOf 'collect(' is 0
          console.log 'collect op'

        when part.indexOf('(') > -1 and part.indexOf(')') > -1
          # it should be a function of some kind
          functionName = part[0..part.indexOf('(')-1]
          source = source.map((el) -> 
            if functionName of el and el[functionName] instanceof Function
              return el[functionName]()
            else
              console.log(el)
              throw new Error("Element does not contain the requested function")
          )
          #console.log('wut', expr)
    return source

###  getAttributeOfElement: (attributeName, element) ->
    switch true
      when element instanceof Node
        test

    # check for brackets, if present, expect a function back!
    console.log(attrbuteName)
    if attributeName in element
      attribute = element[attributeName]
      switch true
        when attribute instanceof Function
          throw new Error("Evaluating function attribute not implemented")
        else
          return attribute
###
module.exports = ExpressionEvaluator