define [
  'spine'
  'viewmodels/drawings/link_canvas_element'
], (Spine, LinkCanvasElement) ->

  describe 'LinkCanvasElement', ->
    describe 'isSource and isTarget', ->
      beforeEach ->
        @id = 5
        @element = new FakeElement()
        @viewModel = new TestLinkCanvasElement(@element)
      
      it 'isSource returns true for node with same id as sourceId', ->
        @element.sourceId = @id
        node = { id: @id }
        expect(@viewModel.isSource(node)).toBeTruthy()
        
      it 'isSource returns false for node with different id as sourceId', ->
        @element.sourceId = @id
        node = { id: @id + 1 }
        expect(@viewModel.isSource(node)).toBeFalsy()
  
      it 'isTarget returns true for node with same id as sourceId', ->
        @element.targetId = @id
        node = { id: @id }
        expect(@viewModel.isTarget(node)).toBeTruthy()
      
      it 'isTarget returns false for node with different id as sourceId', ->
        @element.targetId = @id
        node = { id: @id + 1 }
        expect(@viewModel.isTarget(node)).toBeFalsy() 
    
    describe 'reconnectTo', ->
      beforeEach ->
        @id = 1
        @element = new FakeElement()
        @node = { id: @id }
        @offset = {x: 5, y: 10}
        @paperLink = jasmine.createSpyObj('link', ['reconnectTo', 'segments'])
        
        @reconnect = (paperLink, paperLabel) ->
          viewModel = new TestLinkCanvasElement(@element, paperLink, paperLabel)
          viewModel.reconnectTo(@node, @offset)
      
      it 'delegates to link object to reconnect both source and target', ->
        @element.sourceId = @id
        @element.targetId = @id
        @reconnect(@paperLink)
        
        expect(@paperLink.reconnectTo).toHaveBeenCalledWith(@offset, true, true)
        
      it 'delegates to link object to reconnect source only', ->
        @element.sourceId = @id
        @reconnect(@paperLink)
        
        expect(@paperLink.reconnectTo).toHaveBeenCalledWith(@offset, true, false)
      
      it 'delegates to link object to reconnect target only', ->
        @element.targetId = @id
        @reconnect(@paperLink)
        
        expect(@paperLink.reconnectTo).toHaveBeenCalledWith(@offset, false, true)
      
      it 'delegates to label object', ->
        paperLabel = jasmine.createSpyObj('label', ['move'])
        @reconnect(@paperLink, paperLabel)
        
        expect(paperLabel.move).toHaveBeenCalledWith(@offset)
      
      describe 'returns a command', ->
        it 'of type ReshapeLink', ->
          command = @reconnect(@paperLink)
          expect(command.constructor.name).toBe('ReshapeLink')
      
        it 'with the correct link property', ->
          command = @reconnect(@paperLink)
          expect(command.link).toBe(@element)
        
        it 'with the correct originalSegments property', ->
          originalSegments = [ { x: 0, y: 20 } ]
          @element.segments = originalSegments
        
          command = @reconnect(@paperLink)
          expect(command.originalSegments).toBe(originalSegments)
      
        it 'with the correct newSegments property', ->
          newSegments = [ { x: 10, y: 20 } ]

          paperLink = 
            reconnectTo: ->
       
            segments: -> 
              newSegments
   
          command = @reconnect(paperLink)
          expect(command.newSegments).toBe(newSegments) 
  
  
  
  # A LinkCanvasElement with its stencil creation stubbed out
  class TestLinkCanvasElement extends LinkCanvasElement
    constructor: (element, link = {}, label) ->
      super(element)
      @_link = link   # FIXME hack to override the @_link var created by LinkCanvasElement
      @_label = label # FIXME hack to override the @_label var created by LinkCanvasElement
    
    _stencil: (stencilFactory, shape) ->
      draw: ->
        firstChild: ->
          @children[0]

        lastChild: ->
          @children[@children.length-1]

        children: ->
          if @_label
            [@_link, @_label]
          else
            [@_link]
  
  class FakeElement extends Spine.Module
    @include(Spine.Events)
    
    getShape: ->