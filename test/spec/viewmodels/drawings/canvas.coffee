define [
  'viewmodels/drawings/canvas'
  'viewmodels/drawings/node_canvas_element'
  'viewmodels/drawings/link_canvas_element'
], (Canvas, NodeCanvasElement, LinkCanvasElement) ->

  class MockCanvasElement
    bind: (event, handler) ->

  class MockDrawing
    constructor: ->
      @_nodes = []
      @_links = []
    
    addNode: ->
      node = { type: 'node', id: @_nodes.length+1 }
      @_nodes.push node
      node
    
    addLink: ->
      link = { type: 'link', id: @_links.length+1 }
      @_links.push link
      link
    
    nodes: =>
      all: =>
        @_nodes
    
    links: =>
      all: =>
        @_links
        
    save: ->

  describe 'Canvas', ->
    beforeEach ->
      @canvasElementFactory = { createCanvasElementFor: => }
      @canvasElement = jasmine.createSpyObj('canvasElement', ['toDataURL'])
      @drawing = new MockDrawing
      
    afterEach ->
      @canvas.destruct()
    
    it 'constructs canvas elements on load', ->
      node = @drawing.addNode()
      link = @drawing.addLink()
      
      spyOn(@canvasElementFactory, 'createCanvasElementFor').andReturn(new MockCanvasElement())
      
      @canvas = new Canvas(el: @canvasElement, drawing: @drawing, factory: @canvasElementFactory)
            
      expect(@canvasElementFactory.createCanvasElementFor).toHaveBeenCalledWith(node)
      expect(@canvasElementFactory.createCanvasElementFor).toHaveBeenCalledWith(link)      
      
      
      