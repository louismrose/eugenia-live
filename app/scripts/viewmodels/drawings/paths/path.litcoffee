## Paths
Paths are a key component in the rendering of a drawing. A Path encapsulates
the logic required to draw shapes on the HTML canvas. We currently use the 
Paper.js library to avoid manipulating the HTML canvas directly. Therefore, our
current implementations of Path are all delegates (wrappers) for Paper.js objects.

Clients should instantiate a subclass of Path.

A Path is normally constructed by calling the `draw` method of a Stencil.

    define [], () ->

      class Path
      
The Paper.js object is rendered on construction and whenver redraw is called, by
setting the relevant properties.

        constructor: (@_paperItem, @_properties = {}) ->
          @redraw(@_properties)

        redraw: (properties) =>
          @_paperItem.fillColor = properties.fillColor if properties.fillColor
          @_paperItem.strokeColor = properties.strokeColor if properties.strokeColor
          @_paperItem.position = properties.position if properties.position

Paths can be linked to a view model (e.g., a CanvasElement) so that user interface
events that originate in the HTML canvas can be easily forwarded to our view model
objects. For example, Paper.js hit-testing will locate a Paper.js object, and so we
store a reference to the specified viewModel on the Paper.js object.

        linkToViewModel: (viewModel) =>
          @_paperItem.viewModel = viewModel

The following methods delegate to the parts of the Paper.js API that we need.

        bottomCenter: =>
          @_paperItem.bounds.bottomCenter
  
        width: =>
          @_paperItem.bounds.width

        height: =>
          @_paperItem.bounds.height

        fillColor: =>
          @_paperItem.fillColor

        setFillColor: (fillColor) =>
          @_paperItem.fillColor = fillColor 
    
        strokeColor : =>
          @_paperItem.strokeColor
    
        setStrokeColor: (strokeColor) =>
          @_paperItem.strokeColor = strokeColor

The position of a Path is defined by a point, which is pair of values (x and y).
The representation returned by the `position` method (and accepted by the 
`setPosition` method) is very close to the underlying Paper.js representation
(but does not use Paper.js objects because they do not typically 
serialise/deseralise cleanly).

        position: =>
          x: @_paperItem.position.x
          y: @_paperItem.position.y
        
        setPosition: (position) =>
          @_paperItem.position = position            

A Path exposes several convenience methods for updating their appearance without
forcing the view to manipulate the underlying Paper.js item directly.

        move: (offset) =>
          @_paperItem.position.x += offset.x
          @_paperItem.position.y += offset.y

        select: =>
          @_paperItem.selected = true

        remove: =>
          @_paperItem.remove()