define [
  'paper',
  'viewmodels/drawings/stencils/stencil'
  'viewmodels/drawings/stencils/stencil_specification'
], (paper, Stencil, StencilSpecification) ->

  class LabelStencil extends Stencil
    constructor: (stencilSpecification = {}, @_labelled) ->
      super(stencilSpecification)

    defaultSpecification: =>
      new StencilSpecification(placement: 'none')
    
    draw: (node) ->
      shape = @_labelled.draw(node)
      result = new paper.Group(shape)
      unless @resolve(node, 'placement') is "none"
        result.addChild(@_createText(node, @_positionFor(node, shape)))
      result
  
    _positionFor: (node, shape) ->
      switch @resolve(node, 'placement')
        when "external"
          shape.bounds.bottomCenter.add([0, 20]) # nudge outside shape
        when "internal"
          shape.position # align with centre and middle of shape

    _createText: (node, position) ->
      text = new paper.PointText
        justification: 'center'
        fillColor: @resolve(node, 'color')
        content: @_contentFor(node)
        position: position

      node.properties.bind("propertyChanged propertyRemoved", => 
        text.content = @_contentFor(node)
        # FIXME this should call canvas.updateDrawingCache()
        paper.view.draw()
      )

      text
  
    _contentFor: (node) ->
      content = node.properties.resolve(@resolve(node, 'text'), @resolve(node, 'text'))
      @_trimText(content, @resolve(node, 'length'))
  
    _trimText: (text, maximumLength) ->
      return "" unless text
      return text unless text.length > maximumLength
      return text.substring(0, maximumLength-3).trim() + "..."