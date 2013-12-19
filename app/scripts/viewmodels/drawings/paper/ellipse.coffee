define [
  'paper'
  'viewmodels/drawings/paper/closed_path'
], (paper, ClosedPath) ->

  class Ellipse extends ClosedPath
    constructor: (width, height) ->
      @_path = new paper.Path.Oval(new paper.Rectangle(0, 0, width, height))
    