define [
  'paper'
  'viewmodels/drawings/paper/closed_path'
], (paper, ClosedPath) ->

  class RegularPolygon extends ClosedPath
    constructor: (@sides, @radius) ->
      @_path = new paper.Path.RegularPolygon(new paper.Point(0, 0), sides, radius)
    