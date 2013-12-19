### LineStencil
This class is responsible for rendering lines.

    define [
      'paper'
      'viewmodels/drawings/stencils/stencil'
      'viewmodels/drawings/stencils/stencil_specification'
      'viewmodels/drawings/paper/line'
    ], (paper, Stencil, StencilSpecification, Line) ->
  
      class LineStencil extends Stencil
      
The `color` and `style` properties are used when rendering a Path.
We first set some sensible defaults in case the LinkShape omits values
for any of these properties.

        defaultSpecification: =>
          new StencilSpecification(color: 'black', style: 'solid')
      
When a LineStencil is used to render a Link, we create a Line that
comprises the segments stored in the Link. The segments property will
will be an array of Paper.js segments. We set the appearance of the Line,
according to the `color` and `style` properties.
      
        draw: (link) =>
          new Line(link.segments, @_strokeColor(link), @_isDashed(link))
        
        _strokeColor: (link) =>
          @resolve(link, 'color')

        _isDashed: (link) =>
          @resolve(link, 'style') is 'dash'
          