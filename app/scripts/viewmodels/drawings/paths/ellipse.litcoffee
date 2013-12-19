### Ellipse
This class is responsible for drawing ellipitcal Paths, by using a Paper.js Oval.

    define [
      'paper'
      'viewmodels/drawings/paths/path'
    ], (paper, Path) ->

      class Ellipse extends Path
        constructor: (properties) ->
          bounds = new paper.Rectangle(0, 0, properties.width, properties.height)
          super(new paper.Path.Oval(bounds))
    