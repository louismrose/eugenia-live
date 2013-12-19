define [
  'paper'
  'viewmodels/drawings/paper/closed_path'
], (paper, ClosedPath) ->

  class Rectangle extends ClosedPath
    constructor: (width, height) ->
      @_path = new paper.Path.Rectangle(0, 0, width, height)
    