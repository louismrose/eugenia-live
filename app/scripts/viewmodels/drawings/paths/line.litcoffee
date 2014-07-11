### Line
This class is responsible for drawing Lines, by using a Paper.js Path.

    define [
      'paper'
      'lib/paper/paper_path_mover'
      'viewmodels/drawings/paths/path'
    ], (paper, PaperPathMover, Path) ->

      class Line extends Path
        constructor: (segments, properties) ->
          super(new paper.Path(segments), properties)
      
          # TODO add logic to Path that trims the line at the
          # intersection with its start and end node, rather
          # than hiding the overlap behind the nodes here
          paper.project.activeLayer.insertChild(0, @_paperItem) if paper.project

A Line can be dashed or solid, and we set a `dashArray` on the underlying Paper.js
Path accordingly.
        
        redraw: (properties) =>
          @_paperItem.strokeColor = properties.color
          @_paperItem.dashArray = if properties.dashed then [4,4] else []

A Line can be reshaped by moving its starting point, ending point, or both by the
specified offset.
      
        reshape: (offset, moveStart, moveEnd) ->
          mover = new PaperPathMover(@_paperItem, offset)
          mover.moveStart() if moveStart
          mover.moveEnd() if moveEnd

The shape of a Line is defined by its segments, an array of triples of points. The 
representation returned by the `segments` method (and accepted by the `setSegments` 
method) is very close to the underlying Paper.js representation (but does not use 
Paper.js objects because they do not typically serialise/deseralise cleanly).
       
        segments: =>
          for segment in @_paperItem.segments
            point:
              x: segment.point.x
              y: segment.point.y
              angle: segment.point.angle
            handleIn:
              x: segment.handleIn.x
              y: segment.handleIn.y
              angle: segment.point.angle
            handleOut:
              x: segment.handleOut.x
              y: segment.handleOut.y
              angle: segment.handleOut.angle
        
        setSegments: (segments) ->
          @_paperItem.setSegments(segments)