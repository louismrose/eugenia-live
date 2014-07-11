### Ellipse
This class is responsible for drawing ellipitcal Paths, by using a Paper.js Oval.

    define [
      'paper'
      'viewmodels/drawings/paths/bounded'
    ], (paper, Bounded) ->

      class Ellipse extends Bounded
        _createPaperItem: (bounds) =>
          new paper.Path.Oval(bounds)