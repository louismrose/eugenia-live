define [
  'spine'
  'viewmodels/drawings/node_canvas_element'
], (Spine, NodeCanvasElement) ->

  describe 'NodeCanvasElement', ->
    describe 'on construction', ->    
      it 'draws the node', ->
        element = new FakeElement
        stencil = new FakeStencil
      
        new NodeCanvasElement(element, undefined, new FakeStencilFactory(stencil))
        expect(stencil.drawn).toBeTruthy()
        
      it 'establishes a link to itself from the underlying Paper.js object and all of its descendants', ->
        element = new FakeElement
        
        firstGrandchild = {}
        secondGrandchild = {}
        child = { children: [ firstGrandchild, secondGrandchild ] }
        paperItem = { children : [child] } 
        stencil = new FakeStencil(paperItem)
      
        canvasElement = new NodeCanvasElement(element, undefined, new FakeStencilFactory(stencil))
        expect(paperItem.viewModel).toBe(canvasElement)
        expect(child.viewModel).toBe(canvasElement)
        expect(firstGrandchild.viewModel).toBe(canvasElement)
        expect(secondGrandchild.viewModel).toBe(canvasElement)
  

      describe 'on destruction of the underlying node', ->
        it 'calls remove on the Paper.js object', ->
          element = new FakeElement
          paperItem = new FakePaperItem
          stencil = new FakeStencil(paperItem)
          
          canvasElement = new NodeCanvasElement(element, undefined, new FakeStencilFactory(stencil))
          
          element.trigger("destroy")
          expect(paperItem.removed).toBeTruthy()
          
          
          
  class FakePaperItem
    constructor: () ->
      @removed = false
    
    remove: ->
      @removed = true    
  
  class FakeElement extends Spine.Module
    @include(Spine.Events)
    
    getShape: ->
      
  class FakeStencil
    constructor: (@paperItem = {}) ->
      @drawn = false
    
    draw: ->
      @drawn = true
      @paperItem
      
  class FakeStencilFactory
    constructor: (@_stencil) ->
    
    convertNodeShape: ->
      @_stencil
      