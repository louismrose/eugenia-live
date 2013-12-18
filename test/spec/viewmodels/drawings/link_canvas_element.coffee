define [
  'spine'
  'viewmodels/drawings/link_canvas_element'
], (Spine, LinkCanvasElement) ->

  describe 'LinkCanvasElement', ->
    it "has no tests yet", ->
          
          
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
    
    convertLinkShape: ->
      @_stencil
      
      