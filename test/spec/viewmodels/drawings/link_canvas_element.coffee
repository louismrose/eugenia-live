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
  
  
  # A LinkCanvasElement with its stencil creation stubbed out
  class TestLinkCanvasElement extends LinkCanvasElement
    constructor: (element, @stencil) ->
      super(element)
    
    _stencil: (stencilFactory, shape) ->
      draw: ->
        {}
  
  class FakeElement extends Spine.Module
    @include(Spine.Events)
    
    getShape: ->