define [
  'viewmodels/drawings/stencils/rectangle_stencil'
  'viewmodels/drawings/stencils/rounded_rectangle_stencil'
  'viewmodels/drawings/stencils/ellipse_stencil'
  'viewmodels/drawings/stencils/regular_polygon_stencil'
], (RectangleStencil, RoundedRectangleStencil, EllipseStencil, RegularPolygonStencil) ->

  class StencilFactory
    types:
      rectangle: RectangleStencil
      rounded: RoundedRectangleStencil
      ellipse: EllipseStencil
      polygon: RegularPolygonStencil
      
    stencilFor: (stencilSpecification) =>
      type = @types[stencilSpecification.figure]
      throw new Error("#{stencilSpecification.figure} is not a valid type of stencil") unless type
      new type(stencilSpecification)