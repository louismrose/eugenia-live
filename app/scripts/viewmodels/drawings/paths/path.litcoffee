## Paths
Paths are a key component in the rendering of a drawing. A Path encapsulates
the logic required to draw shapes on the HTML canvas. We currently use the 
Paper.js library to avoid manipulating the HTML canvas directly. Therefore, our
current implementations of Path are all delegates (wrappers) for Paper.js objects.

Clients should instantiate a subclass of Path.

A Path is normally constructed by calling the `draw` method of a Stencil.

    define [], () ->

      class Path
      
Paths render a Paper.js object when they are constructed.

        constructor: (@_paperItem, @_properties = {}) ->
          @_paperItem.fillColor = @_properties.fillColor if @_properties.fillColor
          @_paperItem.strokeColor = @_properties.strokeColor if @_properties.strokeColor
          @_paperItem.position = @_properties.position if @_properties.position

Paths can be linked to a view model (e.g., a CanvasElement) so that user interface
events that originate in the HTML canvas can be easily forwarded to our view model
objects. For example, Paper.js hit-testing will locate a Paper.js object, and so we
store a reference to the specified viewModel on the Paper.js object.

        linkToViewModel: (viewModel) =>
          @_paperItem.viewModel = viewModel

The following methods delegate to the parts of the Paper.js API that we need.

        bottomCenter: ->
          @_paperItem.bounds.bottomCenter
  
        width: ->
          @_paperItem.bounds.width

        height: ->
          @_paperItem.bounds.height

        fillColor: ->
          @_paperItem.fillColor

        setFillColor: (fillColor) =>
          @_paperItem.fillColor = fillColor 
    
        strokeColor : ->
          @_paperItem.strokeColor
    
        setStrokeColor: (strokeColor) =>
          @_paperItem.strokeColor = strokeColor

        position: ->
          @_paperItem.position  
        
        setPosition: (position) ->
          @_paperItem.position = position            

        move: (offset) ->
          @_paperItem.position.x += offset.x
          @_paperItem.position.y += offset.y

        select: ->
          @_paperItem.selected = true

        remove: ->
          @_paperItem.remove()