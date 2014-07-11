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
          @_paths = (stencil.draw(element) for stencil in @_stencils)
          new CompositePath(@_paths)

We redraw a CompositeStencil by delegating to each of the child Stencils,
passing the paths that have been previously drawn.

        redraw: (element) =>
          for stencil, index in @_stencils
            stencil.redraw(element, @_paths[index])
