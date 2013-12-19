### StencilFactory
The following class is responsible for instantiating Stencils from Shapes.

    define [
      'viewmodels/drawings/stencils/line_stencil'
      'viewmodels/drawings/stencils/composite_stencil'
      'viewmodels/drawings/stencils/rectangle_stencil'
      'viewmodels/drawings/stencils/rounded_rectangle_stencil'
      'viewmodels/drawings/stencils/ellipse_stencil'
      'viewmodels/drawings/stencils/regular_polygon_stencil'
      'viewmodels/drawings/stencils/labelled_stencil'
    ], (LineStencil, CompositeStencil, RectangleStencil, RoundedRectangleStencil, EllipseStencil, RegularPolygonStencil, LabelledStencil) ->

StencilFactory exposes methods for converting a LinkShape and for converting a 
NodeShape to a Stencil.

      class StencilFactory

A link shape may contain attributes relating to the path (e.g., `color` or `style`) 
and possibly a label. We add the label stencil last, as it acts as a sort of 
"overlay" for the other stencil(s).

        convertLinkShape: (shape) =>
          @_addLabel(shape, new LineStencil(shape))

A node shape will contain an array of elements and possibly a label. Again, we add the 
label stencil last.

        convertNodeShape: (shape) =>
          @_addLabel(shape, @_convertElements(shape))

When a shape contains a label, we pass along the label's parameters and the stencil
to be wrapped by the LabelledStencil. Otherwise, we simply return the original,
unlabelled stencil.

        _addLabel: (shape, stencil) =>
          if shape.label
            new LabelledStencil(shape.label, stencil)
          else
            stencil
            
A node shape will comprise one or more elements, and we convert each element into a
stencil in turn. We keep track of the number of stencils that were created, returning
a composite stencil only when necessary.
            
        _convertElements: (nodeShape) =>
          stencils = (@_elementToStencil(element) for element in nodeShape.elements)
      
          if stencils.length == 1
            stencils[0]
          else
            new CompositeStencil(stencils)
        
The figure property of an element object indicates which type of stencil must be 
instantiated (e.g., `rectangle` or `ellipse`). We first convert the figure.name 
property to the name of a Coffeescript class, and then instantiate it.
        
        _elementToStencil: (element) =>
          type = @_figureToStencilType(element.figure)
          new type(element)

We store a map (object) that allows us to lookup the Coffeescript class to be
instantiated for each type of figure. This could have been implemented using a 
switch statement.
        
        _figureToStencilType: (figure) =>
          type = @_figures[figure]
          throw new Error("#{stencilSpecification.figure} is not a valid type of stencil") unless type
          type

        _figures:
          rectangle: RectangleStencil
          rounded: RoundedRectangleStencil
          ellipse: EllipseStencil
          polygon: RegularPolygonStencil