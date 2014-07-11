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
        path = @_createPath(stencil, drawingElement)
        new NodeCanvasElement(drawingElement, path, @_canvas)
      else
        stencil = @_stencilFactory.convertLinkShape(drawingElement.getShape())
        path = @_createPath(stencil, drawingElement)
        new LinkCanvasElement(drawingElement, path, @_canvas)
        
    _createPath: (stencil, drawingElement) ->
      path = stencil.draw(drawingElement)
      @_updatePathOnPropertyChanges(path, stencil, drawingElement)
      path
    
    _updatePathOnPropertyChanges: (path, stencil, drawingElement) =>
      drawingElement.properties.bind("propertyChanged propertyRemoved", =>
        # Eventually redraw should supercede these lines (and we can perhaps make resolve private and delete setText?)        
        # newText = stencil.resolve(drawingElement, 'text')
        # path.setText(newText)
        
        stencil.redraw(drawingElement, path)
        @_canvas.updateDrawingCache()
      )