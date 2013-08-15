Node = require('models/node')
Link = require('models/link')

class ExpressionEvaluator

  constructor: () ->
    # do nothing

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
        propertyName = expression.trim()
        unless context.hasPropertyValue propertyName
          console.warn(context, propertyName)
          throw new Error("Element does not contain that property") 
      else
        throw new Error('Element is not of type Node or Link and cannot contain a Property')
    else
      lastDot = expression.lastIndexOf '.'
      # get the target element that is denoted by the first piece of the expression
      target = @getElements(expression[0..lastDot-1], context)
      # assert that the result is (a list of) Nodes/Links here?
      propertyName = expression.substr(lastDot+1).trim()

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
              # use apply instead, with defined arguments as array, or use the FunctionBuilder perhaps
              return el[functionName]()
            else
              console.log(el)
              throw new Error("Element does not contain the requested function")
          )
          #console.log('wut', expr)
    return source


  # TODO: we may want to move 'evaluate' and 'execute' to another location, 
  # as it seems to be more related to a simulation
  evaluate:(context, expression, environment) ->
    pattern = ///\$\{([^\}]*)\}///g
    evalable = expression.replace(pattern, (match, subExpression) =>
      lastDot = subExpression.lastIndexOf '.'
      # get the target element that is denoted by the first piece of the expression
      target = @getElements(subExpression[0..lastDot-1], context)
      # assert that the result is (a list of) Nodes/Links here?
      propertyName = subExpression.substr(lastDot+1).trim()
      if target.length isnt 1
        throw new Error("Cannot evaluate simple property on List of Nodes/Links containing more or less than 1 Element")
      target[0].getPropertyValue(propertyName)
    )
    try 
      eval(evalable)
    catch e
      console.error(e)

  execute: (element, simulationControl, statement, context) =>
    switch true
      when statement.indexOf('trigger(') is 0
        args = statement[statement.indexOf('(')+1..statement.lastIndexOf(')')-1].split(',')
        if args.length is 1
          simulationControl.triggerAll(eventName)
        else if args.length is 2
          eventTargetExpression = args[0]
          eventName = args[1].trim()
          eventName = eventName[1..eventName.length-2] # FIXME: we shouldn't need to trim the quotes...
          simulationControl.trigger(@getElements(eventTargetExpression, element), eventName) 
        else
          throw new Error("Incorrect syntax for trigger")
      when statement.indexOf('+=') > -1
        # TODO: refactor cases for +=, -= and = as they are extremely similar.
        # use some kind of lambda to specify the final action (i.e. respectively current + a or current - a or just a)

        #TODO: add support for |= and &=? this would help solve the race condition for setting something to true
        assignmentParts = statement.split('+=')
        if assignmentParts.length is 2
          # TODO: assign the value of the last assignmentPart to each other assignmentPart
          # TODO: eval the right hand side
          valueToAdd = @evaluate(element, assignmentParts[1], context)
          result = @getProperty(assignmentParts[0], element)
          return ()-> 
            result.target.map((target) -> 
              currentValue = parseFloat(target.getPropertyValue(result.propertyName))
              target.setPropertyValue(result.propertyName, currentValue + valueToAdd)
            )

      when statement.indexOf('-=') > -1
        assignmentParts = statement.split('-=')
        if assignmentParts.length > 1
          # TODO: assign the value of the last assignmentPart to each other assignmentPart
          # TODO: eval the right hand side
          assignmentParts[assignmentParts.length-1]
          valueToSubtract = @evaluate(element, assignmentParts[1], context)
          result = @getProperty(assignmentParts[0], element)
          return ()-> 
            result.target.map((target) -> 
              currentValue = parseFloat(target.getPropertyValue(result.propertyName))
              target.setPropertyValue(result.propertyName, currentValue - valueToSubtract)
            )
      when statement.indexOf('=') > -1
        assignmentParts = statement.split('=')

        if assignmentParts.length > 1
          # TODO: assign the value of the last assignmentPart to each other assignmentPart
          assignmentParts[assignmentParts.length-1]
          newValue = @evaluate(element, assignmentParts[1], context)
          result = @getProperty(assignmentParts[0], element)
          return ()-> 
            result.target.map((target) -> target.setPropertyValue(result.propertyName, newValue))
        else
          throw new Error('Unsupported/unrecognized statement kind')

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