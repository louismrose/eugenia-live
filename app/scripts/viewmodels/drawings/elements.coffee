define [
  'paper'
  'viewmodels/drawings/element_factory'
  'viewmodels/drawings/composite'
], (paper, ElementFactory, Composite) ->

  class Elements
    constructor: (elements, factory = new ElementFactory()) ->
      @elements = (factory.elementFor(element) for element in elements)
      
    draw: (node) ->
      new Composite(@elements).draw(node)