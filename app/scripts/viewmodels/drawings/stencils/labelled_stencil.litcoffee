### LabelledStencil
This class is responsible for rendering labels for Nodes and Links, currently
by drawing a Paper.js PointText.

    define [
      'paper',
      'viewmodels/drawings/stencils/stencil'
      'viewmodels/drawings/stencils/stencil_specification'
      'viewmodels/drawings/paths/labelled_path'
    ], (paper, Stencil, StencilSpecification, LabelledPath) ->

Like CompositeStencil, LabelledStencil is a decorator for other Stencils. When 
we create a LabelledStencil we pass its specification and the Stencil that we 
wish to extend with a label.

      class LabelledStencil extends Stencil
        constructor: (stencilSpecification = {}, @_labelled) ->
          super(stencilSpecification)

The `placement`, `color`, `text` and `length` properties are used when rendering
a label. We first set some sensible defaults in case the NodeShape or LinkShape
omits values for any of these properties.

        defaultSpecification: =>
          new StencilSpecification(placement: 'none', color: 'black', text: '', length: 30)

To draw an element, we first delegate to the child stencil to obtain the Path
to which we will add a label. We then return the Path if the `placement` property
is set to none, or return a LabelledPath to attach a Label to the Path.
            
        draw: (element) ->
          @_labelledPath = @_createLabelledPath(element, @_labelled.draw(element))
        
        redraw: (element, path) =>
          super
          @_labelled.redraw(element, @_labelledPath.path)
        
        _createLabelledPath: (element, labelledItem) ->      
          new LabelledPath(labelledItem, @_properties(element))
          
        _properties: (element) ->
          color: @_resolve(element, 'color')
          text: @_resolve(element, 'text')
          length: @_resolve(element, 'length')
          placement: @_resolve(element, 'placement')
