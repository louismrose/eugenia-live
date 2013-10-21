define [
  'paper'
  'viewmodels/drawings/element_factory'
], (paper, ElementFactory) ->

  class Composite
    constructor: (elements = [], factory = new ElementFactory()) ->
      @elements = (factory.elementFor(element) for element in elements)
    
    draw: (node) =>
      new paper.Group(@_children(node))
    
    _children: (node) =>
      element.draw(node) for element in @elements