define [
  'paper'
], (paper) ->
  
  class Path
    constructor: (@color, @style) ->

    draw: (element) =>
      path = new paper.Path(element.segments)
      path.strokeColor = @color
      path.dashArray = [4, 4] if @style is "dash"
      path
