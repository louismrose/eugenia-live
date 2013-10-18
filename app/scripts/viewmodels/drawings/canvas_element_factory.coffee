define [
  'viewmodels/drawings/node_canvas_element'
  'viewmodels/drawings/link_canvas_element'
  'models/node'
], (NodeCanvasElement, LinkCanvasElement, Node) ->

  class CanvasElementFactory
    constructor: (@_canvas) ->
    
    createCanvasElementFor: (drawingElement) ->
      if drawingElement instanceof Node 
        new NodeCanvasElement(drawingElement, @_canvas)
      else
        new LinkCanvasElement(drawingElement, @_canvas)