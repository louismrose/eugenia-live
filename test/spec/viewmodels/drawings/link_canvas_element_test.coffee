define [
  'spine'
  'viewmodels/drawings/link_canvas_element'
], (Spine, LinkCanvasElement) ->

  describe 'LinkCanvasElement', ->    
    beforeEach ->
      @element = fakeElement()
      @offset = {x: 5, y: 10}
      @path = jasmine.createSpyObj('link', ['reshape', 'segments', 'linkToViewModel'])
      
      @reconnect = ->
        node = {}
        viewModel = new LinkCanvasElement(@element, @path)
        viewModel._reconnectTo(node, @offset)
      
      @getCommand = ->
        node = {}
        viewModel = new LinkCanvasElement(@element, @path)
        viewModel._reconnectTo(node, @offset)
        viewModel._reshapeCommand()
      
    describe 'reconnectTo', ->
      it 'delegates to path to move both source and target', ->
        @element.isSource.andReturn(true)
        @element.isTarget.andReturn(true)
        
        @reconnect()
        expect(@path.reshape).toHaveBeenCalledWith(@offset, true, true)
        
      it 'delegates to path to move source only', ->
        @element.isSource.andReturn(true)
        @element.isTarget.andReturn(false)
        
        @reconnect()
        expect(@path.reshape).toHaveBeenCalledWith(@offset, true, false)
      
      it 'delegates to path to move target only', ->
        @element.isSource.andReturn(false)
        @element.isTarget.andReturn(true)
        
        @reconnect()
        expect(@path.reshape).toHaveBeenCalledWith(@offset, false, true)
      
    describe '_reshapeCommand returns a command', ->
      it 'of type ReshapeLink', ->
        command = @getCommand()
        expect(command.constructor.name).toBe('ReshapeLink')
    
      it 'with the correct link property', ->
        command = @getCommand()
        expect(command.link).toBe(@element)
      
      it 'with the correct originalSegments property', ->
        originalSegments = [ { x: 0, y: 20 } ]
        @element.segments = originalSegments
      
        command = @getCommand()
        expect(command.originalSegments).toBe(originalSegments)
    
      it 'with the correct newSegments property', ->
        newSegments = [ { x: 10, y: 20 } ]
        @path.segments.andReturn(newSegments)

        command = @getCommand()
        expect(command.newSegments).toBe(newSegments) 
  
  fakeElement = ->
    element = jasmine.createSpyObj('stencil', ['getShape', 'isSource', 'isTarget', 'bind', 'trigger'])
    # Emulate a simple implementation of bind and trigger from Spine.Events
    element.bind.andCallFake( (event, handler) => @handler = handler )
    element.trigger.andCallFake( (event) => @handler() )
    element