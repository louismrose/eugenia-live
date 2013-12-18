define [
  'paper'
  'lib/paper/paper_path_mover'
  'viewmodels/drawings/canvas_element'
  'viewmodels/drawings/stencils/stencil_factory'
  'models/commands/delete_link'
  'models/commands/reshape_link'
], (paper, PaperPathMover, CanvasElement, StencilFactory, DeleteLink, ReshapeLink) ->

  class PaperLink
    constructor: (@_path) ->
    
    reconnectTo: (offset, isSource, isTarget) ->
      mover = new PaperPathMover(@_path, offset)
      mover.moveStart() if isSource
      mover.moveEnd() if isTarget
    
    segments: ->
      @_path.segments
  
  class PaperLabel
    constructor: (@_pointText) ->
    
    # should this logic be on the label class?
    move: (offset) ->
      @_pointText.position.x += offset.x
      @_pointText.position.y += offset.y
      

  class LinkCanvasElement extends CanvasElement
    constructor: (element, @_canvas, stencilFactory = new StencilFactory()) ->
      super(element, @_canvas, stencilFactory)
      
      @_link = new PaperLink(@_canvasElement.firstChild)
      @_label = new PaperLabel(@_canvasElement.lastChild) if @_canvasElement.children.length > 1

      # TODO add logic to Path that trims the line at the
      # intersection with its start and end node, rather
      # than hiding the overlap behind the nodes here
      paper.project.activeLayer.insertChild(0, @_canvasElement) if paper.project
    
    isNode: =>
      false
    
    reconnectTo: (node, offset) =>
      @_link.reconnectTo(offset, @_element.isSource(node), @_element.isTarget(node))
      @_label.move(offset) if @_label
      new ReshapeLink(@_element, @_element.segments, @_link.segments())

    _stencil: (stencilFactory, shape) =>
      stencilFactory.convertLinkShape(shape)
    
    _destroyCommand: (drawing) =>
      new DeleteLink(drawing, @_element)