### RegularPolygon
This class is responsible for drawing regular polygon Paths, by using a Paper.js RegularPolygon.

    define [
      'paper'
      'viewmodels/drawings/paths/path'
    ], (paper, Path) ->

      class RegularPolygon extends Path
        constructor: (properties) ->
          origin = new paper.Point(0, 0)
          super(new paper.Path.RegularPolygon(origin, properties.sides, properties.radius), properties)
    