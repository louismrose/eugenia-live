define [], () ->
  
  class ReshapeLink
    constructor: (@link, @originalSegments, @newSegments) ->
  
    run: =>
      @link.reshape(@newSegments)
  
    undo: =>
      @link.reshape(@originalSegments)
    