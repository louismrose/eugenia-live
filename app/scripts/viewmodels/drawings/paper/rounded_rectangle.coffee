define [
  'paper'
  'viewmodels/drawings/paper/closed_path'
], (paper, ClosedPath) ->

  class RoundedRectangle extends ClosedPath
    constructor: (width, height) ->
      bounds = new paper.Rectangle(0, 0, width, height)
      @_path = new paper.Path.RoundRectangle(bounds, new paper.Size(10, 10))
    