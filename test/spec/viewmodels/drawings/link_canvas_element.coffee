define [
  'viewmodels/drawings/link_canvas_element'
], (LinkCanvasElement) ->

  describe 'LinkCanvasElement', ->
    it 'loads', ->
      new LinkCanvasElement(new FakeElement, undefined, new FakeStencilFactory)
      
  
  class FakeElement
    getShape: ->
    bind: (event, handler) ->
      
  class FakeStencilFactory
    convertLinkShape: ->
      draw: (link) ->
        {}
      