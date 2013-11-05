define [
  'jquery'
  'viewmodels/drawings/canvas'
  'viewmodels/drawings/node_canvas_element'
  'viewmodels/drawings/link_canvas_element'
], ($, Canvas, NodeCanvasElement, LinkCanvasElement) ->

  class MockCanvasElement
    constructor: (@_element) ->
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
      $('body').append($('<canvas/>'))
      @canvasElementFactory = { createCanvasElementFor: (e) => new MockCanvasElement(e) }
      @canvasElement = $('canvas')[0]
      @drawing = new MockDrawing
      
    afterEach ->
      @canvas.destruct()
    
    it 'constructs canvas elements on load', ->
      node = @drawing.addNode()
      link = @drawing.addLink()
      
      spyOn(@canvasElementFactory, 'createCanvasElementFor').andCallThrough()
      
      @canvas = new Canvas(el: @canvasElement, drawing: @drawing, factory: @canvasElementFactory)
            
      expect(@canvasElementFactory.createCanvasElementFor).toHaveBeenCalledWith(node)
      expect(@canvasElementFactory.createCanvasElementFor).toHaveBeenCalledWith(link)      
      
      
    it 'can differentiate between nodes and links with the same id', ->
      node = @drawing.addNode()
      link = @drawing.addLink()
      
      # If this fails, the test is broken
      expect(node.id).toBe(link.id)
      
      @canvas = new Canvas(el: @canvasElement, drawing: @drawing, factory: @canvasElementFactory)
      
      expect(@canvas.elementFor(node)).not.toBe(@canvas.elementFor(link))
      
      