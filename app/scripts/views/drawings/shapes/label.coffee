define [], () ->

  class Label
    constructor: (definition) ->
      @definition = definition
    
      if @definition and @definition.placement isnt "none"
        @definition.for = [@definition.for] unless @definition.for instanceof Array
        @definition.pattern = @default_pattern() unless @definition.pattern
      else
        @definition = { placement: "none" }
  
    default_pattern: ->
      numbers = [0..@definition.for.length-1]
      formattedNumbers = ("{#{n}}" for n in numbers)
      formattedNumbers.join(",")
  
    draw: (node, shape) ->
      result = new paper.Group(shape)
    
      unless @definition.placement is "none"
        result.addChild(@createText(node, @positionFor(shape)))

      result
  
    positionFor: (shape) ->
      if @definition.placement is "external"
        shape.bounds.bottomCenter.add([0, 20]) # nudge outside shape
      else
        shape.position.add([0, 5]) # nudge down to middle of shape

    createText: (node, position) ->
      text = new paper.PointText(position)
      text.justification = 'center'
      text.fillColor = @definition.color
      text.content = @contentFor(node)
      node.properties.bind("propertyChanged propertyRemoved", => 
        text.content = @contentFor(node)
        # FIXME this should call canvas.updateDrawingCache()
        paper.view.draw()
      )
      text
  
    contentFor: (node) ->
      # TODO: can't this be done by name? e.g. a key-value binding?
      content = @definition.pattern    
      for number in [0..@definition.for.length-1]
        pattern = ///
          \{
          #{number}
          \}
        ///g
        value = node.properties.get(@definition.for[number])
        content = content.replace(pattern, value)
    
      @trimText(content)
  
    trimText: (text) ->
      return "" unless text
      return text unless text.length > @definition.length
      return text.substring(0, @definition.length-3).trim() + "..."