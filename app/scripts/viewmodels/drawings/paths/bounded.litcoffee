### Bounded
This class is responsible for providing common logic for Paths that can be bounded by a rectangle.

    define [
      'paper'
      'viewmodels/drawings/paths/path'
    ], (paper, Path) ->

The width and height properties are used to determine the bounds of the path to be constructed.
Subclasses are expected to provide a strategy for constructing a Paper.js item that respects 
these bounds.

      class Bounded extends Path
        constructor: (properties) ->
          bounds = new paper.Rectangle(0, 0, properties.width, properties.height)
          super(@_createPaperItem(bounds), properties)

Redrawing a Bounded path involves adjusting the width and height of the underlying Paper.js 
item.
        
        redraw: (properties) =>
          # Ensure that bounds are changed before the position is set to
          # avoid the paper item from being moved to a different position
          @_paperItem.bounds.width = properties.width
          @_paperItem.bounds.height = properties.height
          super
        
        # Subclasses must implement this method
        _createPaperItem: (bounds) =>
          throw new Error("Instantiate a subclass rather than this class directly.")
          