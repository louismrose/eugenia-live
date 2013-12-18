define [
  'spine'
  'viewmodels/drawings/stencils/stencil_factory'
], (Spine, StencilFactory) ->

  class CanvasElement extends Spine.Module
    @include(Spine.Events)
    
    constructor: (@_element, @_canvas = undefined, stencilFactory = new StencilFactory()) ->
      stencil = @_stencil(stencilFactory, @_element.getShape())
      @_canvasElement = stencil.draw(@_element)

      @_linkToThis(@_canvasElement)      
      @_element.bind("destroy", @_remove)
      
    _linkToThis: (paperItem) =>
      paperItem.viewModel = @
      @_linkToThis(c) for c in paperItem.children if paperItem.children
    
    _remove: =>
      @_canvasElement.remove()
      
    
    select: =>
      @_canvas.clearSelection()
      @_canvasElement.firstChild.selected = true
      @_element.select()
    
    destroy: =>
      @_canvas.run(@_destroyCommand(@_canvas.drawing))