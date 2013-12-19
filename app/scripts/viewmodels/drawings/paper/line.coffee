define [
  'paper'
  'lib/paper/paper_path_mover'
], (paper, PaperPathMover) ->

  class Line
    constructor: (segments, strokeColor, isDashed) ->
      @_path = new paper.Path(segments)
      @_path.strokeColor = strokeColor
      @_path.dashArray = [4, 4] if isDashed
      
      # TODO add logic to Path that trims the line at the
      # intersection with its start and end node, rather
      # than hiding the overlap behind the nodes here
      paper.project.activeLayer.insertChild(0, @_path) if paper.project
    
    move: (offset, isSource, isTarget) ->
      mover = new PaperPathMover(@_path, offset)
      mover.moveStart() if isSource
      mover.moveEnd() if isTarget
    
    segments: ->
      @_path.segments
    
    linkToViewModel: (viewModel) =>
      @_path.viewModel = viewModel
      
    remove: ->
      @_path.remove()
      
    select: ->
      @_path.selected = true
    
    position: ->
      @_path.position
    
    strokeColor: ->
      @_path.strokeColor
      
    dashArray: ->
      @_path.dashArray