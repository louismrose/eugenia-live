define [
  'viewmodels/drawings/stencils/stencil_factory'
  'viewmodels/drawings/node_canvas_element'
  'viewmodels/drawings/link_canvas_element'
  'models/node'
], (StencilFactory, NodeCanvasElement, LinkCanvasElement, Node) ->

  class CanvasElementFactory
    constructor: (@_canvas) ->
      @_stencilFactory = new StencilFactory()
    
    createCanvasElementFor: (drawingElement) ->
      if drawingElement instanceof Node 
        stencil = @_stencilFactory.convertNodeShape(drawingElement.getShape())
        new NodeCanvasElement(drawingElement, stencil.draw(drawingElement), @_canvas)
      else
        stencil = @_stencilFactory.convertLinkShape(drawingElement.getShape())
        new LinkCanvasElement(drawingElement, stencil.draw(drawingElement), @_canvas)