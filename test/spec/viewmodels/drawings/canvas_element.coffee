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
    
    describe 'destroy', ->
      it "runs the command created by _destroyCommand()", ->
        canvas = new FakeCanvas
        command = {}
        
        canvasElement = new TestCanvasElement(@element, new FakeStencil, canvas, command)
        canvasElement.destroy()

        expect(canvas.ran).toBeTruthy()
        expect(canvas.command).toBe(command)
    
    describe 'select', ->
      beforeEach ->
        @canvas = jasmine.createSpyObj('paperItem', ['clearSelection'])
        @paperItem = { firstChild: {} }
        spyOn(@element, 'select')
        
        canvasElement = new TestCanvasElement(@element, new FakeStencil(@paperItem), @canvas)
        canvasElement.select()
      
      it "clears the existing selection", ->
        expect(@canvas.clearSelection).toHaveBeenCalled()
    
      it "selects the firstChild of the Paper.js object", ->
        expect(@paperItem.firstChild.selected).toBeTruthy()
    
      it "selects the underlying drawing element", ->
        expect(@element.select).toHaveBeenCalled()
          
          
  # A minimal implementation of the CanvasElement interface
  class TestCanvasElement extends CanvasElement
    constructor: (element, @stencil, canvas, @command) ->
      super(element, canvas)
    
    _stencil: (stencilFactory, shape) ->
      @stencil
      
    _destroyCommand: () ->
      @command
  
  class FakeElement extends Spine.Module
    @include(Spine.Events)
    
    getShape: ->
    select: ->
      
  class FakeStencil
    constructor: (@paperItem = {}) ->
      @drawn = false
    
    draw: ->
      @drawn = true
      @paperItem
      
  class FakeCanvas
    constructor: ->
      @ran = false
    
    run: (command) ->
      @command = command
      @ran = true