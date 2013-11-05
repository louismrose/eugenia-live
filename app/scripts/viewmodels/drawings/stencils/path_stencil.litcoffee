### PathStencil
This class is responsible for rendering Links, currently by drawing a 
Paper.js Path.

    define [
      'paper'
      'viewmodels/drawings/stencils/stencil'
      'viewmodels/drawings/stencils/stencil_specification'
    ], (paper, Stencil, StencilSpecification) ->

The `color` and `style` properties are used when rendering a Path.
We first set some sensible defaults in case the LinkShape omits values
for any of these properties.
  
      class PathStencil extends Stencil
        defaultSpecification: =>
          new StencilSpecification(color: 'black', style: 'solid')
      
When a PathStencil is used to render a Link, we create a Paper.js Path
that comprises the segments stored in the Link. The segments property 
will be an array of Paper.js segments. We then set the stroke color 
and dash array of the Path, according to the `color` and `style` properties.
      
        draw: (link) =>
          path = new paper.Path(link.segments)
          path.strokeColor = @resolve(link, 'color')
          path.dashArray = [4, 4] if @resolve(link, 'style') is 'dash'
          path
