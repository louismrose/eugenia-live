### CompositeStencil
This class provides a mechanism for constructing a Stencil by combining 
together one or more other Stencils.

    define [
      'viewmodels/drawings/paths/composite_path'
    ], (CompositePath) ->

A composite stencil comprises an array of Stencils.

      class CompositeStencil
        constructor: (@_stencils = []) ->

We draw a CompositeStencil by calling draw() on each of the child Stencils
and storing the resulting Paths in a CompositePath.
    
        draw: (element) =>
          new CompositePath(@_paths(element))
    
        _paths: (element) =>
          stencil.draw(element) for stencil in @_stencils
