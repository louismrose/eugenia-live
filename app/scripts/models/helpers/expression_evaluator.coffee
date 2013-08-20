Node = require('models/node')
Link = require('models/link')
simulationPoll = require('controllers/simulation_poll')

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
          # FIXME: what about non-unique occurrences, need to have them twice?
          # e.g. from N1--L1-->N2 and N1--L2-->N3--L3-->N2
          # where N1.outgoing.target().outgoing.target() would include N2 twice
          source = source.map((el)->el.outgoingLinks()).reduce((a, b)-> a.concat(b))
        when part.trim().toLowerCase() is 'incoming'
          source = source.map((el)->el.incomingLinks()).reduce((a, b)-> a.concat(b))
        when part.indexOf 'collect(' is 0
          console.log 'collect op'

        when part.indexOf('(') > -1 and part.indexOf(')') > -1

          if part.indexOf('ofType') is 0
            args = part.split('(')[1].split(')')[0].split(',') # this is too awful for words, but works when using a lot of assumptions
            source = source.filter((el)-> el.ofType(args[0]))
          else if part.indexOf('first()') > -1
            source = [source[0]]
          else if part.indexOf('last()') > -1
            source = [source[source.length-1]]
          else
            # it should be a function of some kind
            functionName = part[0..part.indexOf('(')-1]
            source = source.map((el) -> 
              if functionName of el and el[functionName] instanceof Function
                args = part.split('(')[1].split(')')[0].split(',') # this is too awful for words, but works when using a lot of assumptions
                # use apply instead, with defined arguments as array, or use the FunctionBuilder perhaps
                return el[functionName].apply(el, args)
              else
                console.log(el, part, functionName, args)
                throw new Error("Element does not contain the requested function")
            )
    return source

  evaluate:(context, expression, environment) ->
    expression = expression.replace("sim.time", simulationPoll.displayTime(), "gi")
    expression = expression.replace("sim.step", simulationPoll.timeStep, "gi")
    pattern = ///\$\{([^\}]*)\}///g
    evalable = expression.replace(pattern, (match, subExpression) =>
      lastDot = subExpression.lastIndexOf '.'
      # get the target element that is denoted by the first piece of the expression
      target = @getElements(subExpression[0..lastDot-1], context)
      # assert that the result is (a list of) Nodes/Links here?
      propertyName = subExpression.substr(lastDot+1).trim()
      if target.length > 1
        #throw new Error("Cannot evaluate simple property on List of Nodes/Links containing more or less than 1 Element")
        console.warn('Using first element in the list of elements found')

      if target.length >= 1 and target[0]
        target[0].getPropertyValue(propertyName) 
      else
        return undefined
    )
    if evalable.indexOf(';') > -1
      try
        return eval(evalable)
      catch e
        console.error(expression, e, evalable)
    else
      number = parseFloat(evalable)
      if not isNaN(number)
        return number
      return evalable

  createSetters: (element, statement, operator, internalSetter, context) ->
    assignmentParts = statement.split(operator)
    if assignmentParts.length isnt 2
      throw new Error("Incorrect flow for assignment operator, check your assignment statements", statement)

    # TODO: assign the value of the last assignmentPart to each other assignmentPart
    otherValue = @evaluate(element, assignmentParts[1], context)
    result = @getProperty(assignmentParts[0], element)
    return ()-> 
      result.target.map((target) -> 
        currentValue = parseFloat(target.getPropertyValue(result.propertyName))
        target.setPropertyValue(result.propertyName, internalSetter(currentValue, otherValue), false)
      )

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
      ## addition
      when statement.indexOf('+=') > -1
        return @createSetters(element, statement, '+=', ((current, other) -> current + other), context)
      ## subtraction
      when statement.indexOf('-=') > -1
        return @createSetters(element, statement, '-=', ((current, other) -> current - other), context)
      ## multiplication
      when statement.indexOf('*=') > -1
        return @createSetters(element, statement, '*=', ((current, other) -> current * other), context)
      ## division
      when statement.indexOf('/=') > -1
        return @createSetters(element, statement, '/=', ((current, other) -> current / other), context)
      ## logical or
      when statement.indexOf('|=') > -1
        return @createSetters(element, statement, '|=', ((current, other) -> current || other), context)
      ## logical and
      when statement.indexOf('&=') > -1
        return @createSetters(element, statement, '&=', ((current, other) -> current && other), context)
      ## assignment of literal
      when statement.indexOf('=') > -1
        return @createSetters(element, statement, '=', ((current, other) -> other), context)
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