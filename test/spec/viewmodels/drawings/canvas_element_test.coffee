define [
  'viewmodels/drawings/canvas_element'
], (CanvasElement) ->

  describe 'CanvasElement', ->
    beforeEach ->
      @element = fakeElement()
      @path = fakePath()
    
    describe 'on construction', ->          
      it 'establishes a link from the underlying path to itself', ->
        canvasElement = new TestCanvasElement(@element, @path)
        expect(@path.linkToViewModel).toHaveBeenCalledWith(canvasElement)
      
    describe 'on destruction of the underlying node', ->
      it 'calls remove on the Paper.js object', ->
        canvasElement = new TestCanvasElement(@element, @path)
        @element.trigger("destroy")
        expect(@path.remove).toHaveBeenCalled()
    
    describe 'destroy', ->
      it "runs the command created by _destroyCommand()", ->
        canvas = jasmine.createSpyObj('canvas', ['run'])
        command = {}
        
        canvasElement = new TestCanvasElement(@element, @path, canvas, command)
        canvasElement.destroy()

        expect(canvas.run).toHaveBeenCalledWith(command)
    
    describe 'select', ->
      beforeEach ->
        @canvas = jasmine.createSpyObj('canvas', ['clearSelection'])
        canvasElement = new TestCanvasElement(@element, @path, @canvas)
        canvasElement.select()
      
      it "clears the existing selection", ->
        expect(@canvas.clearSelection).toHaveBeenCalled()
    
      it "selects the underlying path", ->
        expect(@path.select).toHaveBeenCalled()
    
      it "selects the underlying drawing element", ->
        expect(@element.select).toHaveBeenCalled()
          
  
  fakeElement = ->
    element = jasmine.createSpyObj('stencil', ['getShape', 'select', 'bind', 'trigger'])
    # Emulate a simple implementation of bind and trigger from Spine.Events
    element.bind.andCallFake( (event, handler) => @handler = handler )
    element.trigger.andCallFake( (event) => @handler() )
    element
    
  fakePath = ->
    jasmine.createSpyObj('path', ['linkToViewModel', 'select', 'remove'])
     
  # A minimal implementation of the CanvasElement interface
  class TestCanvasElement extends CanvasElement
    constructor: (element, path, canvas, @command) ->
      super(element, path, canvas)
    
    _destroyCommand: () ->
      @command