define [], ->

  class ClosedPath
    move: (offset, isSource, isTarget) ->
      @_path.position.x += offset.x
      @_path.position.y += offset.y
    
    linkToViewModel: (viewModel) =>
      @_path.viewModel = viewModel 

    setPosition: (position) =>
      @_path.position = position
      
    setFillColor: (fillColor) =>
      @_path.fillColor = fillColor 
      
    setStrokeColor: (strokeColor) =>
      @_path.strokeColor = strokeColor
    
    remove: ->
      @_path.remove()
      
    select: ->
      @_path.selected = true
    
    position: ->
      @_path.position
    
    bottomCenter: ->
      @_path.bounds.bottomCenter
      
    width: ->
      @_path.bounds.width
    
    height: ->
      @_path.bounds.height