## Stencils
Stencils are a key component in the rendering of a drawing. A Stencil
encapsulates the logic required to render a category of Nodes or Links. A 
Stencil is constructed from a NodeShape or from a LinkShape by a StencilFactory.
Much like their real-life counterparts, Stencils can be used repeatedly to 
draw Nodes (Links) with the same NodeShape (LinkShape).

A Stencil provides a method, normally called `draw(element)` that renders the
given Node or Link. We currently use the Paper.js library to perform rendering 
on an HTML Canvas, so our current implementations of Stencil all delegate to
the Paper.js library.

    define [
      'viewmodels/drawings/stencils/stencil_specification'
    ], (StencilSpecification) ->
  
Most Stencils use a number of user-defined properties during rendering, such as
properties that control the size or shape of the resulting rendered item. Access 
to these properties is provided via an instance of SpencilSpecification.
  
      class Stencil
        constructor: (stencilSpecification = {}) ->
          @_specification = new StencilSpecification(stencilSpecification)
          @_specification.merge(@defaultSpecification())

All Stencils should provide sensible default values for the properties on which
they rely. The following method is overriden in subclasses of Stencil to provide
these default values.

        # Subclasses must implement this method    
        defaultSpecification: =>
          throw new Error("Instantiate a subclass rather than this class directly.")
    
Property values can contain Expressions that need to be evaluated in the context 
of the Node (Link) which is to be rendered. For example, the content of a label 
might be defined as `"${forename} ${surname}"`, in which the `${forename}` and 
`${surname}` placeholders should be replaced by the `forename` and `surname` 
properties of the Node (Link) which is currently being rendered. To implement 
this, we delegate to the `resolve` method in PropertySet.
    
        resolve: (element, key) =>
          # When an option has a dynamic value, such as ${foo}
          # resolve it using the element's property set
          element.properties.resolve(@_specification.get(key), @defaultSpecification().get(key))