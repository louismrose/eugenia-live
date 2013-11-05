### CompositeStencil
This class provides a mechanism for constructing a Stencil by combining 
together one or more other Stencils.

    define [
      'paper'
    ], (paper) ->

A composite stencil comprises an array of Stencils.

      class CompositeStencil
        constructor: (@_stencils = []) ->

We draw a CompositeStencil by calling draw() on each of the child Stencils
and storing the resulting Paper.js Items in a Paper.js Group.
    
        draw: (element) =>
          new paper.Group(@_items(element))
    
        _items: (element) =>
          stencil.draw(element) for stencil in @_stencils
