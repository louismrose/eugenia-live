### RegularPolygon
This class is responsible for drawing regular polygon Paths, by using a Paper.js RegularPolygon.

    define [
      'paper'
      'viewmodels/drawings/paths/path'
    ], (paper, Path) ->

      class RegularPolygon extends Path
        constructor: (@sides, @radius) ->
          @_paperItem = new paper.Path.RegularPolygon(new paper.Point(0, 0), sides, radius)
    