define [
  'paper'
], (paper) ->
  
  class Path
    constructor: (shape) ->
      @color = shape.color || "black"
      @style = shape.style || "solid"

    draw: (element) =>
      path = new paper.Path(element.segments)
      path.strokeColor = @color
      path.dashArray = [4, 4] if @style is "dash"
      path
