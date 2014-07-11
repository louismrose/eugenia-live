### Rectangle
This class is responsible for drawing rectangular Paths, by using a Paper.js Rectangle.

    define [
      'paper'
      'viewmodels/drawings/paths/bounded'
    ], (paper, Bounded) ->

      class Rectangle extends Bounded
        _createPaperItem: (bounds) =>
          new paper.Path.Rectangle(bounds)
