### RegularPolygon
This class is responsible for drawing regular polygon Paths, by using a Paper.js RegularPolygon.

    define [
      'paper'
      'viewmodels/drawings/paths/path'
    ], (paper, Path) ->

      class RegularPolygon extends Path
        constructor: (properties) ->
          super(@_createPaperItem(properties), properties)
    
        redraw: (properties) =>
          @remove()
          @_paperItem = @_createPaperItem(properties)
          super
        
        _createPaperItem: (properties) =>
          new paper.Path.RegularPolygon(new paper.Point(0, 0), properties.sides, properties.radius)