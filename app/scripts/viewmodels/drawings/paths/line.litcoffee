### Line
This class is responsible for drawing Lines, by using a Paper.js Path.

    define [
      'paper'
      'lib/paper/paper_path_mover'
      'viewmodels/drawings/paths/path'
    ], (paper, PaperPathMover, Path) ->

      class Line extends Path
        constructor: (segments, @_properties) ->
          super(@_createPath(segments, @_properties.color, @_properties.dashed), @_properties)
      
          # TODO add logic to Path that trims the line at the
          # intersection with its start and end node, rather
          # than hiding the overlap behind the nodes here
          paper.project.activeLayer.insertChild(0, @_paperItem) if paper.project

A Line can be dashed or solid, and we set a `dashArray` on the underlying Paper.js
Path accordingly.
    
        _createPath: (segments, color, dashed) ->
          path = new paper.Path(segments)
          path.strokeColor = color
          path.dashArray = [4, 4] if dashed
          path

A Line can be reshaped by moving its starting point, ending point, or both by the
specified offset.
      
        reshape: (offset, moveStart, moveEnd) ->
          mover = new PaperPathMover(@_paperItem, offset)
          mover.moveStart() if moveStart
          mover.moveEnd() if moveEnd
          @_paperItem.segments