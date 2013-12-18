define [
  'paper'
  'lib/paper/paper_path_mover'
  'viewmodels/drawings/canvas_element'
  'viewmodels/drawings/stencils/stencil_factory'
  'models/commands/delete_link'
  'models/commands/reshape_link'
], (paper, PaperPathMover, CanvasElement, StencilFactory, DeleteLink, ReshapeLink) ->

  class LinkCanvasElement extends CanvasElement
    constructor: (element, @_canvas, stencilFactory = new StencilFactory()) ->
      super(element, @_canvas, stencilFactory)

      # TODO add logic to Path that trims the line at the
      # intersection with its start and end node, rather
      # than hiding the overlap behind the nodes here
      paper.project.activeLayer.insertChild(0, @_canvasElement) if paper.project
    
    isNode: =>
      false
      
    isSource: (node) =>
      node.id is @_element.sourceId
      
    isTarget: (node) =>
      node.id is @_element.targetId
    
    reconnectTo: (node, offset) =>
      mover = new PaperPathMover(@_canvasElement.firstChild, offset)
      mover.moveStart() if @isSource(node)
      mover.moveEnd() if @isTarget(node)
      
      # Move label too -- should this logic be on the label class?
      @_canvasElement.lastChild.position.x += offset.x
      @_canvasElement.lastChild.position.y += offset.y
      
      new ReshapeLink(@_element, @_element.segments, @_canvasElement.firstChild.segments)


    _stencil: (stencilFactory, shape) =>
      stencilFactory.convertLinkShape(shape)
    
    _destroyCommand: (drawing) =>
      new DeleteLink(drawing, @_element)