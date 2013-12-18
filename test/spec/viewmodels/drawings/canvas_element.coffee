define [
  'spine'
  'viewmodels/drawings/canvas_element'
], (Spine, CanvasElement) ->

  describe 'CanvasElement', ->
    beforeEach ->
      @element = new FakeElement
    
    describe 'on construction', ->          
      it 'draws the drawing element', ->
        stencil = new FakeStencil
        new TestCanvasElement(@element, stencil)
        expect(stencil.drawn).toBeTruthy()
        
      it 'establishes a link to itself from the underlying Paper.js object and all of its descendants', ->
        # construct tree of fake Paper.js items
        firstGrandchild = {}
        secondGrandchild = {}
        child = { children: [ firstGrandchild, secondGrandchild ] }
        paperItem = { children : [child] } 
        stencil = new FakeStencil(paperItem)
      
        canvasElement = new TestCanvasElement(@element, stencil)
        
        expect(paperItem.viewModel).toBe(canvasElement)
        expect(child.viewModel).toBe(canvasElement)
        expect(firstGrandchild.viewModel).toBe(canvasElement)
        expect(secondGrandchild.viewModel).toBe(canvasElement)
        
      
      describe 'on destruction of the underlying node', ->
        it 'calls remove on the Paper.js object', ->
          paperItem = jasmine.createSpyObj('paperItem', ['remove'])
          
          canvasElement = new TestCanvasElement(@element, new FakeStencil(paperItem))
          @element.trigger("destroy")
          
          expect(paperItem.remove).toHaveBeenCalled()
          
          
  # A minimal implementation of the CanvasElement interface
  class TestCanvasElement extends CanvasElement
    constructor: (element, @stencil) ->
      super(element)
    
    _stencil: (stencilFactory, shape) ->
      @stencil 
  
  class FakeElement extends Spine.Module
    @include(Spine.Events)
    
    getShape: ->
      
  class FakeStencil
    constructor: (@paperItem = {}) ->
      @drawn = false
    
    draw: ->
      @drawn = true
      @paperItem