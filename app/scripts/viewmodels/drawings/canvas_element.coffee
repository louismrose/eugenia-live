define [
  'spine'
  'viewmodels/drawings/stencils/stencil_factory'
], (Spine, StencilFactory) ->

  class CanvasElement extends Spine.Module
    @include(Spine.Events)
    
    constructor: (@_element, @_path, @_canvas) ->
      @_path.linkToViewModel(@)
      @_element.bind("destroy", @_path.remove)
    
    select: =>
      # TODO should this be implemented using events, like destroy -> remove (above) ?
      @_canvas.clearSelection()
      @_path.select()
      @_element.select()
    
    destroy: =>
      @_canvas.run(@_destroyCommand(@_canvas.drawing))