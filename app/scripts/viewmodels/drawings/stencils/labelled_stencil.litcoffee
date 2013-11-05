### LabelledStencil
This class is responsible for rendering labels for Nodes and Links, currently
by drawing a Paper.js PointText.

    define [
      'paper',
      'viewmodels/drawings/stencils/stencil'
      'viewmodels/drawings/stencils/stencil_specification'
    ], (paper, Stencil, StencilSpecification) ->

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
          labelledItem = @_labelled.draw(element)
          new Label(@, element, labelledItem).draw()
        
A label encapsulates that state necessary to render a label for a particular
drawing element and add it to a Paper.js Item.

      class Label
        constructor: (@_stencil, @_element, @_labelledItem) ->
        
We wrap the Paper.js Item in a Group. We add a PointText element to the Group if
the `placement` property has a value other than `none`.

        draw: ->
          result = new paper.Group(@_labelledItem)
          result.addChild(@_createPointText()) unless @_resolve('placement') is "none"
          result

We create the Paper.js PointText, after calculating the fill colour, content, and 
position of the label.
  
        _createPointText: (position) ->
          text = new paper.PointText
            justification: 'center'
            fillColor: @_resolve('color')
            content: @_content()
            position: @_position()
          @_updateContentOnPropertyChanges(text)
          text
        
When a property value changes, the content of the label might need to be updated.
Therefore, we bind to change events on the element's PropertySet.
        
        _updateContentOnPropertyChanges: (text) ->
          @_element.properties.bind("propertyChanged propertyRemoved", => 
            text.content = @_content()
            # FIXME this should call canvas.updateDrawingCache()
            paper.view.draw()
          )
  
We calculate the content of a label as the value of its `text` property, trimmed
to a maximum size dictated by its `length` property.
  
        _content: ->
          @_trimText(@_resolve('text'), @_resolve('length'))
        
        _trimText: (text, maximumLength) ->
          return "" unless text
          return text unless text.length > maximumLength
          return text.substring(0, maximumLength-3).trim() + "..."

We calculate the position of a label differently depending on the value of its
`placement` property. An `external` label is positioned below the bottom centre
point of the bounds of the item to which the label is attached. An `internal` 
label is positioned at the centre of the bounds of the item to which the label 
is attached.
  
        _position: () ->
          switch @_resolve('placement')
            when "external"
              @_labelledItem.bounds.bottomCenter.add([0, 20]) # nudge outside shape
            when "internal"
              @_labelledItem.position # align with centre and middle of shape  
    
Resolution of property values is delegated to the LabelStencil.

        _resolve: (key) ->
          @_stencil.resolve(@_element, key)
    

We return the LabelledStencil to Require.js so that other files that import
this class have access to only the LabelledStencil class.
    
      LabelledStencil