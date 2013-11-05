## StencilFactory
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

A shape will contain an array of elements and possibly a label. We add the 
label stencil last, as it acts as a sort of "overlay" for the other stencil(s).

      class StencilFactory
        convert: (shape) =>
          @_addLabel(shape, @_convertElements(shape))

When a shape contains a label, we pass along the label's parameters and the stencil
to be wrapped by the label stencil. Otherwise, we simply return the original,
unlabelled stencil.

        _addLabel: (shape, stencil) =>
          if shape.label
            new LabelStencil(shape.label, stencil)
          else
            stencil
            
The shape will comprise one or more elements, and we convert each element into a
stencil in turn. We keep track of the number of stencils that were created, returning
a composite stencil only when necessary.
            
        _convertElements: (shape) =>
          stencils = (@_elementToStencil(element) for element in shape.elements)
      
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