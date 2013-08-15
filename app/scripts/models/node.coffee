define [
  'spine'
  'models/link'
  'models/node_shape'
  'models/helper/expression_evaluator'
  'spine.relation'
], (Spine, Link, NodeShape, ExpressionEvaluator) ->
  
  class Node extends Spine.Model
    @configure "Node", "shape", "position", "propertyValues"
    @belongsTo 'drawing', 'models/drawing'
    
    constructor: (attributes) ->
      super
      @k = v for k,v of attributes
      @initialisePropertyValues()

    initialisePropertyValues: ->
      @propertyValues or= {}
      # Don't call save() during initialisation, as this causes
      # duplicate Spine records to be created.
      @updatePropertyValuesWithDefaultsFromShape(false)
      
    getAllProperties: ->
      @updatePropertyValuesWithDefaultsFromShape(true)
      @propertyValues

    updatePropertyValuesWithDefaultsFromShape: (persist) ->
      for property,value of @defaultPropertyValues()
        # insert the default value unless there is already a value for this property
        @setPropertyValue(property,value,persist) unless @hasPropertyValue(property)
      
      for property,value of @propertyValues
        # remove the current value unless this property is currently defined for this shape
        @removePropertyValue(property,persist) unless property of @defaultPropertyValues()
    
    defaultPropertyValues: ->
      if @getShape() then @getShape().defaultPropertyValues() else {}
  
    setPropertyValue: (property, value, persist = true) ->
      @propertyValues[property] = value
      @save() if persist
  
    removePropertyValue: (property, persist = true) ->
      delete @propertyValues[property]
      @trigger("propertyRemove")
      @save() if persist

    hasPropertyValue: (property) ->
      property of @propertyValues
  
    getPropertyValue: (property) ->
      @propertyValues[property]
    
    links: =>
      Link.select (link) => (link.sourceId is @id) or (link.targetId is @id)
      
    incomingLinks: =>
      Link.select (link) => (link.targetId is @id)
    
    outgoingLinks: =>
      Link.select (link) => (link.sourceId is @id)

    moveBy: (distance) =>
      @position = distance.add(@position)
      link.reconnectTo(@id, distance) for link in @links()
      @save()
      
    moveTo: (position) =>
      @moveBy(new paper.Point(position).subtract(@position))

    paperId: =>
      "node" + @id

    toPath: =>
      path = @getShape().draw(@)
      path.name = @paperId()
      path
  
    select: (layer) =>
      layer.children[@paperId()].selected = true
  
    destroy: (options = {}) =>
      destroyed = super(options)
      memento =
        shape: destroyed.shape
        position: destroyed.position
  
    getShape: =>
      NodeShape.find(@shape) if @shape and NodeShape.exists(@shape)
      
  evaluate:(expression) =>
    pattern = ///\$\{(.+)\}///g
    evalable = expression.replace(pattern, (match, subExpression) =>
      ###splits = subExpression.split('=')
      if splits.length is 1
        return "(this.getPropertyValue('#{subExpression}'))"
      else if splits.length is 2
        return "(this.setPropertyValue('#{splits[0]}', #{splits[1]}))"
      ###
      return "(this.getPropertyValue('#{subExpression}'))"
    )
    return eval(evalable)

  execute: (simulationControl, statement, context) =>
    evaluator = new ExpressionEvaluator
    switch true
      when statement.indexOf('trigger(') is 0
        args = statement[statement.indexOf('(')+1..statement.lastIndexOf(')')-1].split(',')
        if args.length is 1
          simulationControl.triggerAll(eventName)
        else if args.length is 2
          eventTargetExpression = args[0]
          eventName = args[1].trim()
          eventName = eventName[1..eventName.length-2] # FIXME: we shouldn't need to trim the quotes...
          simulationControl.trigger(evaluator.getElements(eventTargetExpression, @), eventName) 
        else
          throw new Error("Incorrect syntax for trigger")
      when statement.indexOf('+=') is 0
        #pass
        throw new Error('deferred increment: TODO')
      when statement.indexOf('-=') is 0
        #pass
        throw new Error('deferred decrement: TODO')
      when statement.indexOf('=') > -1
        assignmentParts = statement.split('=')

        if assignmentParts.length > 1
          # assign the value of the last assignmentPart to each other assignmentPart
          assignmentParts[assignmentParts.length-1]
          newValue = assignmentParts[1]
          result = evaluator.getProperty(assignmentParts[0], @)
          return ()-> 
            result.target.map((target) -> target.setPropertyValue(result.propertyName, newValue))
        else
          throw new Error('Unsupported/unrecognized statement kind')
          matches = statement.match(pattern)

  simulate: (simulationControl) =>
    setters = []
    if @getShape().behavior and @getShape().behavior.tick
      for statement in @getShape().behavior.tick
        pattern = ///
        \$\{
        (.+)
        \}
        ///g
        #props = @getAllProperties(false)
        evalable = statement.replace(pattern, (match, subExpression) =>
          # seeing that this is a proxied function, 'this' refers to the global object, and '_this' refers to the object this function should be proxied from
          # so we want to have a nice replacement (e.g. replace this, self or even @ with _this everywhere)
          # check whether or not it is an assignment; 
          # FIXME: what to do with ${$}{s}}statements? which order are they executed in?
          if subExpression.contains '='
            s = subExpression.split('=')
            targetExpression = s[0]
            
            #console.log(value)

            if targetExpression.contains('.')
              lastDotIndex = targetExpression.lastIndexOf('.')
              targeted = targetExpression.substr(0, lastDotIndex)
              target = eval(targeted)

              property = targetExpression.substr(lastDotIndex + 1)
              
            else
              target = @
              property = valueExpression

            setters.push( ()=>
                # extract and calculate the current value (the one that will be used to calculate the new target value)
                valueExpression = s[1]
                if valueExpression.contains('.')
                  lastDotIndex = valueExpression.lastIndexOf('.')
                  sourceExpression = valueExpression.substr(0, lastDotIndex)
                  source = eval(sourceExpression)

                  property = valueExpression.substr(lastDotIndex + 1)
                  value = source.getPropertyValue(property)
                else
                  #source = @
                  #property = valueExpression
                  # assume it is a literal for now:
                  value = eval(valueExpression)

                
                #console.log("setting "+ targetExpression + " to ", value)

                # there should be two options (and a syntax to separate them); one that uses the value 'as it is' and one that uses the value 'as it was'

                # TODO  use the value as it is, when the trigger is fired?

                # use the value as it was, when this event started
                target.setPropertyValue(property, value)
            )
          else
            # if there is a dot in there, get the target first, then call getPropertyValue on that
            # if there is no dot, assume 'this' as target
            # the part after the last dot should be used as the name of the property that we want to get the value from
            @getPropertyValue(subExpression)
        )
    setters
