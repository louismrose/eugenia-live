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
      super(element, stencilFactory)

      # TODO add logic to Path that trims the line at the
      # intersection with its start and end node, rather
      # than hiding the overlap behind the nodes here
      paper.project.activeLayer.insertChild(0, @_canvasElement) if paper.project
    
    _stencil: (stencilFactory, shape) =>
      stencilFactory.convertLinkShape(shape)
    
    destroy: =>
      @_canvas.commander.run(new DeleteLink(@_canvas.drawing, @_element))
    
    reconnectTo: (node, offset) =>
      mover = new PaperPathMover(@_canvasElement.firstChild, offset)
      mover.moveStart() if @isSource(node)
      mover.moveEnd() if @isTarget(node)
      
      # Move label too -- should this logic be on the label class?
      @_canvasElement.lastChild.position.x += offset.x
      @_canvasElement.lastChild.position.y += offset.y
      
      new ReshapeLink(@_element, @_element.segments, @_canvasElement.firstChild.segments)

    isSource: (node) =>
      node.id is @_element.sourceId
      
    isTarget: (node) =>
      node.id is @_element.targetId

    isNode: =>
      false
      
    select: =>
      @_canvas.clearSelection()
      @_canvasElement.firstChild.selected = true
      @_element.select()

