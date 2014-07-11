### RoundedRectangle
This class is responsible for drawing rounded rectangular Paths, by using a Paper.js RoundRectangle.

    define [
      'paper'
      'viewmodels/drawings/paths/bounded'
    ], (paper, Bounded) ->

      class RoundedRectangle extends Bounded
        _createPaperItem: (bounds) =>
          borderRadius = new paper.Size(10, 10)
          new paper.Path.RoundRectangle(bounds, borderRadius)
    