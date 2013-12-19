### Rectangle
This class is responsible for drawing rectangular Paths, by using a Paper.js Rectangle.

    define [
      'paper'
      'viewmodels/drawings/paper/path'
    ], (paper, Path) ->

      class Rectangle extends Path
        constructor: (properties) ->
          super(paper.Path.Rectangle(0, 0, properties.width, properties.height))
    