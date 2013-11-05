define [
  'spine'
  'paper'
  'lib/paper/paper_path_mover'
  'viewmodels/drawings/stencils/stencil_factory'
  'models/commands/delete_link'
  'models/commands/reshape_link'
], (Spine, paper, PaperPathMover, StencilFactory, DeleteLink, ReshapeLink) ->

  class LinkCanvasElement extends Spine.Module
    @include(Spine.Events)
    
    constructor: (@element, @canvas) ->
      @draw()
      @linkToThis(@canvasElement)
      
      @element.bind("reshape", @updateSegments)
      @element.bind("destroy", @remove)

    # TODO make "private"
    draw: =>
      stencil = new StencilFactory().convertLinkShape(@element.getShape())
      @canvasElement = stencil.draw(@element)
      # TODO add logic to Path that trims the line at the
      # intersection with its start and end node, rather
      # than hiding the overlap behind the nodes here
      paper.project.activeLayer.insertChild(0, @canvasElement)
    
    # TODO make "private"
    linkToThis: (canvasElement) =>
      canvasElement.canvasElement = @
      @linkToThis(c) for c in canvasElement.children if canvasElement.children
    
    # TODO make "private"
    remove: =>
      @canvasElement.remove()
      @trigger("destroy")

    # TODO make "private"
    updateSegments: =>
      @canvasElement.remove()
      @canvasElement = @element.toPath()
      @linkToThis(@canvasElement)
      @linkToModel(@canvasElement)
      
      # TODO trim the line in the tool
      # rather than hiding the overlap behind the nodes here
      paper.project.activeLayer.insertChild(0, @canvasElement)

    destroy: =>
      @canvas.commander.run(new DeleteLink(@canvas.drawing, @element))
    
    reconnectTo: (node, offset) =>
      mover = new PaperPathMover(@canvasElement.firstChild, offset)
      mover.moveStart() if @isSource(node)
      mover.moveEnd() if @isTarget(node)
      mover.finalise()
      new ReshapeLink(@element, @element.segments, @canvasElement.firstChild.segments)

    isSource: (node) =>
      node.id is @element.sourceId
      
    isTarget: (node) =>
      node.id is @element.targetId

    isNode: =>
      false
      
    select: =>
      @canvas.clearSelection()
      @canvasElement.selected = true
      @element.select()

