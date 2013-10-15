define [], () ->

  class NullCanvasElement
    constructor: (@canvas) ->
    
    select: =>
      @canvas.clearSelection()
    
    isNode: =>
      false
    
    isLink: =>
      false