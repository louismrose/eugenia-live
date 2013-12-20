### RoundedRectangle
This class is responsible for drawing rounded rectangular Paths, by using a Paper.js RoundRectangle.

    define [
      'paper'
      'viewmodels/drawings/paths/path'
    ], (paper, Path) ->

      class RoundedRectangle extends Path
        constructor: (properties) ->
          bounds = new paper.Rectangle(0, 0, properties.width, properties.height)
          borderRadius = new paper.Size(10, 10)
          super(new paper.Path.RoundRectangle(bounds, borderRadius), properties)
    