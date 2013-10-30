define [
  'paper',
], (paper) ->

  class Label
    constructor: (@_definition = {}) ->
      @_definition.placement or= "none"
    
    draw: (node, shape) ->
      result = new paper.Group(shape)
    
      unless @_definition.placement is "none"
        result.addChild(@_createText(node, @_positionFor(shape)))

      result
  
    _positionFor: (shape) ->
      switch @_definition.placement
        when "external"
          shape.bounds.bottomCenter.add([0, 20]) # nudge outside shape
        when "internal"
          shape.position # align with centre and middle of shape

    _createText: (node, position) ->
      text = new paper.PointText
        justification: 'center'
        fillColor: @_definition.color
        content: @_contentFor(node)
        position: position

      node.properties.bind("propertyChanged propertyRemoved", => 
        text.content = @_contentFor(node)
        # FIXME this should call canvas.updateDrawingCache()
        paper.view.draw()
      )

      text
  
    _contentFor: (node) ->
      content = node.properties.resolve(@_definition.text, @_definition.text)
      @_trimText(content)
  
    _trimText: (text) ->
      return "" unless text
      return text unless text.length > @_definition.length
      return text.substring(0, @_definition.length-3).trim() + "..."