### LabelledStencil
This class is responsible for rendering labels for Nodes and Links, currently
by drawing a Paper.js PointText.

    define [
      'paper',
      'viewmodels/drawings/stencils/stencil'
      'viewmodels/drawings/stencils/stencil_specification'
      'viewmodels/drawings/paper/labelled_path'
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

To draw an element, we first delegate to the child stencil to obtain the 
Paper.js Item to which we will add a label. We then use the private Label class
to attach a Paper.js PointText to the Item.
            
        draw: (element) ->
          placement = @resolve(element, 'placement')
          labelledItem = @_labelled.draw(element)
          
          if placement is 'none'
            labelledItem
          else
            @_createLabelledPath(element, labelledItem)
        
        _createLabelledPath: (element, labelledItem) ->
          color = @resolve(element, 'color')
          content = @resolve(element, 'text')
          length = @resolve(element, 'length')
          placement = @resolve(element, 'placement')
          
          labelledPath = new LabelledPath(color, content, length, placement, labelledItem)
          element.properties.bind("propertyChanged propertyRemoved", =>
            content = @resolve(element, 'text')
            labelledPath.refresh(content)
          )
          labelledPath