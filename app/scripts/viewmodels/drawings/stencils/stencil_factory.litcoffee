# Rendering
The following class is responsible for instantiating Stencils from Shapes.
Stencils are used to render the elements of a drawing. Stencils are 
constructed from Shapes, which are defined by users. Shapes specify both 
the abstract and concrete syntax of drawing elements.

    define [
      'viewmodels/drawings/stencils/composite_stencil'
      'viewmodels/drawings/stencils/rectangle_stencil'
      'viewmodels/drawings/stencils/rounded_rectangle_stencil'
      'viewmodels/drawings/stencils/ellipse_stencil'
      'viewmodels/drawings/stencils/regular_polygon_stencil'
      'viewmodels/drawings/stencils/label_stencil'
    ], (CompositeStencil, RectangleStencil, RoundedRectangleStencil, EllipseStencil, RegularPolygonStencil, LabelStencil) ->

      class StencilFactory
        convert: (shape) =>
          @_addLabel(shape, @_convertElements(shape))

        _addLabel: (shape, stencil) =>
          if shape.label
            new LabelStencil(shape.label, stencil)
          else
            stencil
            
        _convertElements: (shape) =>
          stencils = (@_elementToStencil(element) for element in shape.elements)
      
          if stencils.length == 1
            stencils[0]
          else
            new CompositeStencil(stencils)
        
        _elementToStencil: (element) =>
          type = @_figureToStencilType(element.figure)
          new type(element)
        
        _figureToStencilType: (figure) =>
          type = @_figures[figure]
          throw new Error("#{stencilSpecification.figure} is not a valid type of stencil") unless type
          type

        _figures:
          rectangle: RectangleStencil
          rounded: RoundedRectangleStencil
          ellipse: EllipseStencil
          polygon: RegularPolygonStencil